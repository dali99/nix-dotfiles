{ config, lib, pkgs, overlays, ... }:
{
  nixpkgs.overlays = overlays;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  nixpkgs.config.allowUnfree = true;

  imports = [ ../profiles ];

  machine = {
    name = "DanixLaptop";
    eth = "enp0s31f6";
    wlan = "wlp5s0";
    cores = 4;
  };
  profiles.base.enable = true;
  profiles.base.plus = true;
  profiles.gui.enable = true;
  profiles.xsession.enable = true;
  profiles.zsh.enable = true;

  services.gammastep =  {
    enable = true;
    dawnTime = "7:00-8:15";
    duskTime = "21:30-22:30";
  };

  services.activitywatch = {
    enable = true;
    watchers = {
      aw-watcher-afk = {
        package = pkgs.activitywatch;
        settings = {
          timeout = 300;
          poll_time = 2;
        };
      };
      aw-watcher-window = {
        package = pkgs.activitywatch;
        settings = {
          poll_time = 1;
          # exclude_title = true;
        };
      };
    };
  };

  profiles.games.enable = true;
}
