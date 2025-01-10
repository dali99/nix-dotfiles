{ config, lib, pkgs, overlays, ... }:
{
  nixpkgs.overlays = overlays;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  nixpkgs.config.allowUnfree = true;

  imports = [ ../profiles ];

  machine = {
    name = "ikari";
    eth = "eno1";
    wlan = null;
  };
  profiles.base.enable = true;
  profiles.base.plus = true;
  profiles.xsession.enable = true;
  profiles.audio.fancy = true;
  profiles.zsh.enable = true;

  profiles.games.enable = true;

  home.packages = [
      pkgs.unstable.osu-lazer
  ];
}
