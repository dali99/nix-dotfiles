{ config, lib, pkgs, ... }:
{
  imports = [ ../profiles ];

  machine = {
    name = "DanixLaptop";
    eth = "enp0s25";
  };
  profiles.base.enable = true;
  profiles.gui.enable = true;
  profiles.xsession.enable = true;
  profiles.zsh.enable = true;

  profiles.games.enable = true;

  programs.home-manager = {
    enable = true;
    path = "https://github.com/rycee/home-manager/archive/release-20.09.tar.gz";
  };
}
