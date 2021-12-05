{ config, pkgs, username, hostname, ... }:

{
  imports = [
    ../modules/sway/sway.nix
  ];
  
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = username + "-" + hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp3s0.useDHCP = true;

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
    wget nano firefox-wayland tree ag lsof git idea.idea-community maven jdk11 gnumake tig gparted acpi htop freecad hibernate arduino php74Packages.composer redis pstree lm_sensors cpufrequtils font-awesome waybar pavucontrol wirelesstools iw networkmanager neofetch fzf brightnessctl jq wev wdisplays wofi hicolor-icon-theme _1password _1password-gui slack xwayland pv php docker docker-compose google-cloud-sdk mutagen arcanist cloud-sql-proxy
    (import ../modules/vim.nix)
  ];

  services.physlock.enable = true;
  services.physlock.allowAnyUser = true;

  environment.variables = {
    EDITOR = "vim";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

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
  sound.enable = true;
  hardware.pulseaudio.enable = true;
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
      extraGroups = [ "wheel" "sway" ];
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
}
