{ config, lib, pkgs, ... }:
{
  imports = [ ../profiles ];

  machine = {
    name = "DanixLaptop";
    eth = "enp0s31f6";
    wlan = "wlp5s0";
  };
  profiles.base.enable = true;
  profiles.gui.enable = true;
  profiles.xsession.enable = true;
  profiles.zsh.enable = true;

  profiles.games.enable = true;

  programs.home-manager = {
    enable = true;
    path = "https://github.com/rycee/home-manager/archive/release-21.05.tar.gz";
  };
}
