{ config, pkgs, ... }:

{
  environment = {
    etc = {
      "sway/config".source = ./sway_config;
    };
    variables = {
      _JAVA_AWT_WM_NONREPARENTING = "1";
      MOZ_ENABLE_WAYLAND = "1";
      XDG_CURRENT_DESKTOP = "sway";
    };
  };

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
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

  systemd.user.services.kanshi = {
    description = "Kanshi output autoconfig ";
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = ''
      ${pkgs.kanshi}/bin/kanshi
      '';
      RestartSec = 5;
      Restart = "always";
    };
  };

  programs.waybar.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
      ];
    };
  };
}
