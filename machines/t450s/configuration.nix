# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      <nixos-hardware/lenovo/thinkpad/t450s>
      ./hardware-configuration.nix
      (import ../common.nix {config = config; pkgs = pkgs; username = "andrejs"; hostname = "t450s";})
    ];

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/9e8daa89-dcb9-4c87-bdae-8f8813b665c6";
      preLVM = true;
      allowDiscards = true;
    };
  };

  #hardware.bluetooth.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?
}
