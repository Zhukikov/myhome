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
}
