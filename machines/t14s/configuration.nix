# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; ref = "master"; }}/lenovo/thinkpad/t14s/amd/gen1"
      ./hardware-configuration.nix
      (import ../common.nix {config = config; pkgs = pkgs; username = "andrejs"; hostname = "t14s";})
      (import ./boozt.nix)
    ];

  boot.kernelPackages = pkgs.lib.mkForce (pkgs.linuxPackagesFor (pkgs.linux_6_1.override {
    argsOverride = rec {
      src = pkgs.fetchurl {
        url = "mirror://kernel/linux/kernel/v6.x/linux-${version}.tar.xz";
        sha256 = "Pk2OVh2lcDogWujXsr7WxcZPxCme68v9IEgeY7V9XuM=";
      };
      version = "6.1.6";
      modDirVersion = "6.1.6";
    };
  }));


  # luks
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/c615ec42-d4f5-4378-8e61-edbb1a284cf4";
      preLVM = true;
    };
  };

  services.fstrim.enable = true;
  hardware.bluetooth.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}
