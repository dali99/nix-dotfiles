{ config, lib, pkgs, overlays, ... }:
{
  nixpkgs.overlays = overlays;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  nixpkgs.config.allowUnfree = true;

  imports = [ ../profiles ];

  machine = {
    name = "Soryu";
    eth = "enp9s0";
    wlan = null;
    secondary-fs = null;
  };

  profiles.base.enable = true;
  profiles.base.plus = true;
  profiles.xsession.enable = true;
  profiles.audio.fancy = true;
  profiles.zsh.enable = true;

  profiles.games.enable = true;

  profiles.timetracking.enable = true;

  home.packages = [
      pkgs.unstable.osu-lazer-bin
  ];

  home.stateVersion = "24.11";
}
