{ config, lib, pkgs, ... }:
{
  imports = [ ../profiles ];

  machine = {
    name = "DanixDesktop";
    eth = "eno1";
    wlan = null;
  };
  profiles.base.enable = true;
  profiles.xsession.enable = true;
  profiles.zsh.enable = true;

  profiles.games.enable = true;

  programs.home-manager = {
    enable = true;
    path = "https://github.com/rycee/home-manager/archive/release-21.11.tar.gz";
  };
}
