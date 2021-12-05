{ config, pkgs, ... }:

{
  environment = {
    etc = {
      "sway/config".source = ./sway_config;
    };
  };

  programs.sway = {
    enable = true;
    extraPackages = with pkgs; [
      swayidle
      xwayland # for legacy apps
      alacritty
      dmenu
      waybar # status bar
      mako # notification daemon
      kanshi # autorandr
    ];
  };

  programs.waybar.enable = true;
}
