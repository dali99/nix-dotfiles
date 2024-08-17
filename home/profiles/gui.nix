{ config, lib, pkgs, ... }:

let
  cfg = config.profiles.base;
in {

  options.profiles.gui = {
    enable = lib.mkEnableOption "Whether or not to install programs with user-interfaces";
  };

} 
