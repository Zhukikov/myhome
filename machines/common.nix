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
  imports = [
    ../modules/sway/sway.nix
  ];
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 42;
  # Prevent auth bypassing.
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
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
  time.timeZone = "Europe/Stockholm";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget nano unstable.firefox-wayland google-chrome tree ripgrep lsof git jetbrains.idea-community maven jdk11 gnumake tig gparted acpi htop freecad hibernate arduino php74 php74Packages.composer redis pstree lm_sensors cpufrequtils font-awesome waybar pavucontrol wirelesstools iw networkmanager neofetch fzf brightnessctl jq wev wdisplays wofi hicolor-icon-theme _1password-gui slack xwayland pv docker-compose google-cloud-sdk mutagen arcanist cloud-sql-proxy unzip dbeaver jetbrains.phpstorm xdg-utils usbutils grim slurp imv mtpaint wl-clipboard swappy gnome3.adwaita-icon-theme ranger zathura hyperfine gh elixir_ls wf-recorder mpv pinta dnsutils dive
    (import ../modules/vim.nix)
  ];

  services.physlock.enable = true;
  services.physlock.allowAnyUser = true;

  environment.variables = {
    EDITOR = "vim";
    HISTCONTROL = "ignoredups:erasedups";
    HISTSIZE = "10000";
  };

  environment.interactiveShellInit = ''
    # append history
    shopt -s histappend
  '';

  environment.homeBinInPath = true;

  # Fonts
  fonts.fonts = with pkgs; [
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
    START_CHARGE_THRESH_BAT0 = "75";
    STOP_CHARGE_THRESH_BAT0 = "90";
  };
  services.upower.enable = true;

  system.autoUpgrade.enable = true;
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
