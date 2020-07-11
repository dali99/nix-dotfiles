{ config, lib, pkgs, ... }:

let
  cfg = config.profiles.games;
  gui = config.profiles.gui;
in {

  options.profiles.games = {
    enable = lib.mkEnableOption "Whether or not to install video game software";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      fortune
      lolcat
      neofetch
      pipes
    ] ++ lib.optionals config.profiles.gui.enable [
      steam

      multimc
#     minetest
#     dwarf-fortress-packages.dwarf-fortress-full
#     superTuxKart
#     warsow
      xonotic
      zeroad

#     dolphinEmuMaster
    ];
  };
}
