{ config, lib, pkgs, ... }:
{
  imports = [ ../profiles ];

  machine = {
    name = "DanixLaptop";
    eth = "enp0s25";
  };
  profiles.base.enable = true;
  profiles.xsession.enable = true;
  profiles.zsh.enable = true;


  programs.home-manager = {
    enable = true;
    path = "https://github.com/rycee/home-manager/archive/release-20.03.tar.gz";
  };
}
