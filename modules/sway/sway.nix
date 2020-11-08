{ config, pkgs, ... }:

{
  environment = {
    etc = {
      #"sway/config" = {
      #  text = ''
      #    bar {
      #      swaybar_command waybar
      #    } 
      #  '';
      #};
      #"xdg/waybar/config".source = ./dotfiles/waybar/config;
      #"xdg/waybar/style.css".source = ./dotfiles/waybar/style.css;
      "sway/config".source = ./sway_config;
      "xdg/waybar/config".source = ./waybar_config;
    };
  };
}
