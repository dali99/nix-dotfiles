{ config, lib, pkgs, overlays, ... }:
{
  nixpkgs.overlays = overlays;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  nixpkgs.config.allowUnfree = true;

  imports = [ ../profiles ];

  machine = {
    name = "DanixDesktop";
    eth = "eno1";
    wlan = null;
    secondary-fs = "/mnt/henning";
  };
  profiles.base.enable = true;
  profiles.base.plus = true;
  profiles.xsession.enable = true;
  profiles.zsh.enable = true;

  profiles.games.enable = true;
}
