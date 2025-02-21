{ config, lib, pkgs, overlays, ... }:
let
  cfg = config.profiles.timetracking;
in {
  options.profiles.timetracking = {
    enable = lib.mkEnableOption "doin timetracking";
  };

  config = lib.mkIf cfg.enable {  
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
  };
}
