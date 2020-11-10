{ config, pkgs, ... }:

{
  environment = {
    etc = {
      "sway/config".source = ./sway_config;
    };
  };
}
