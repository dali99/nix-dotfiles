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

      unstable.prismlauncher
#     minetest
#     dwarf-fortress-packages.dwarf-fortress-full
#     superTuxKart
#     warsow
#      xonotic
      # zeroad
      unstable.osu-lazer

#      nur.repos.ivar.sm64ex
#     dolphinEmuMaster
    ];
  };
}
