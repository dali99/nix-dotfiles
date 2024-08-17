{ config, lib, pkgs, ... }:

let
  cfg = config.profiles.non-nixos;
in {

  options.profiles.non-nixos = {
    enable = lib.mkEnableOption "Whether or not the profile is running on non-nixos";
  };

} 
