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

  services.gammastep =  {
    enable = true;
    dawnTime = "7:00-8:15";
    duskTime = "21:30-22:30";
  };

  profiles.games.enable = true;

  programs.home-manager = {
    enable = true;
    path = "https://github.com/rycee/home-manager/archive/release-22.05.tar.gz";
  };
}
