{ config, lib, pkgs, ... }:
{
  imports = [ ../profiles ];

  machine = {
    name = "PVV Terminal";
    eth = null;
    wlan = null;
  };
  profiles.base.enable = true;
  profiles.gui.enable = true;
  profiles.non-nixos.enable = true;
  profiles.xsession.enable = true;
  profiles.zsh.enable = true;

  profiles.audio.fancy = false;

  services.gammastep =  {
    enable = true;
    dawnTime = "7:00-8:15";
    duskTime = "21:30-22:30";
  };

  profiles.games.enable = false;

  programs.home-manager = {
    enable = true;
    path = "https://github.com/rycee/home-manager/archive/release-21.11.tar.gz";
  };
}
