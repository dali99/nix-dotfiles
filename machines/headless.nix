{ config, lib, pkgs, overlays, ... }:
{
  nixpkgs.overlays = overlays;

  imports = [ ../profiles ];

  machine = {
    name = "Headless";
    eth = null;
    wlan = null;
    secondary-fs = null;
  };

  profiles.base.enable = true;
  profiles.zsh.enable = true;
}
