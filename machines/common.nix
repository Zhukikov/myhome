{ config, pkgs, username, hostname, ... }:
let
  unstable = import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    { config = config.nixpkgs.config; overlays = [(self: super: {
    _1password-gui = super._1password-gui.overrideAttrs(old: {
	  version = "8.2.0";
	  src = super.fetchurl {
		url = "https://downloads.1password.com/linux/tar/stable/x86_64/1password-8.2.0.x64.tar.gz";
		sha256 = "1hnpvvval8a9ny5x5zffn5lf5qrwc4hcs3jvhqmd7m4adh2i6y2i";
	  };
    });
  })];};
in
{
  nixpkgs.overlays = [
    (final: prev: {
      dbeaver = prev.dbeaver.overrideAttrs (old: {
        desktopItems = [
          (pkgs.makeDesktopItem {
            name = "dbeaver";
            exec = "env GDK_BACKEND=x11 dbeaver";
            icon = "dbeaver";
            desktopName = "dbeaver";
            comment = "SQL Integrated Development Environment";
            genericName = "SQL Integrated Development Environment";
            categories = [ "Development" ];
          })
        ];
      });
    })
  ];
  imports = [
    ../modules/sway/sway.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 42;
  # Prevent auth bypassing.
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = username + "-" + hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.networkmanager.dhcp = "internal";
  networking.networkmanager.wifi.backend = "iwd";
  networking.networkmanager.wifi.powersave = false;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  # Don't use this and rely on geoclue2 settings below.
  # time.timeZone = "Europe/Stockholm";

  services.ntp.enable = true;
  services.automatic-timezoned.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    powertop
    wget
    nano
    firefox
    tree
    ripgrep
    lsof
    git
    jetbrains.idea-community
    maven
    jdk11
    gnumake
    tig
    gparted
    acpi
    htop
    freecad
    hibernate
    arduino
    php81
    php81Packages.composer
    redis
    pstree
    lm_sensors
    cpufrequtils
    font-awesome
    waybar
    pavucontrol
    wirelesstools
    iw
    networkmanager
    neofetch
    fzf
    brightnessctl
    jq
    wev
    wdisplays
    wofi
    hicolor-icon-theme
    _1password-gui
    slack
    xwayland
    pv
    docker-compose
    (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    mutagen
    google-cloud-sql-proxy
    unzip
    jetbrains.phpstorm
    xdg-utils
    usbutils
    grim
    slurp
    imv
    mtpaint
    wl-clipboard
    swappy
    gnome3.adwaita-icon-theme
    ranger
    zathura
    hyperfine
    gh
    elixir_ls
    wf-recorder
    mpv
    pinta
    dnsutils
    dive
    kubernetes-helm
    argocd
    fluxcd
    k9s
    terraform_1
    wavemon
    killall
    inetutils
    unstable.burpsuite
    ngrok
    #postman TODO: Build fails in 23.11
    dbeaver
    (import ../modules/vim.nix)
  ];

  services.fwupd.enable = true;

  environment.variables = {
    EDITOR = "vim";
    HISTCONTROL = "ignoredups:erasedups";
    HISTSIZE = "10000";
    ERL_AFLAGS = "-kernel shell_history enabled";
  };

  environment.interactiveShellInit = ''
    # append history
    shopt -s histappend
  '';

  environment.homeBinInPath = true;

  # Fonts
  fonts.packages = with pkgs; [
    pkgs.font-awesome
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  programs.ssh.startAgent = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 80 7474 7687 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.support32Bit = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = false;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the Gnome Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome3.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers = builtins.listToAttrs [{
    name = username;
    value = {
      isNormalUser = true;
      extraGroups = [ "wheel" "sway" "docker" "networkmanager" ];
      initialPassword = username;
    };
  }];

  nixpkgs.config.allowUnfree = true;

  powerManagement.cpuFreqGovernor = "schedutil";

  services.tlp.enable = true;
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    START_CHARGE_THRESH_BAT0 = "75";
    STOP_CHARGE_THRESH_BAT0 = "80";
    PLATFORM_PROFILE_ON_AC = "balanced";
    PLATFORM_PROFILE_ON_BAT = "low-power";
  };

  services.upower.enable = true;
  powerManagement.powertop.enable = true;

  system.autoUpgrade.enable = false;
  system.autoUpgrade.allowReboot = false;

  nix.gc.automatic = true;
  nix.gc.dates = "weekly";
  nix.gc.options = "--delete-older-than 15d";
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  services.avahi.enable = true;
}
