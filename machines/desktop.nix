{ config, lib, pkgs, ... }:
{
  imports = [ ../profiles ];

  machine = {
    name = "DanixDesktop";
    eth = "eno1";
  };
  profiles.base.enable = true;
  profiles.xsession.enable = true;
  profiles.zsh.enable = true;

  profiles.games.enable = true;

  programs.home-manager = {
    enable = true;
    path = "https://github.com/rycee/home-manager/archive/release-21.05.tar.gz";
  };
}
