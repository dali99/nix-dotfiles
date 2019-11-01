{ pkgs, config, lib, ...}:

{

  home.packages = with pkgs; [
    dan.rank_photos
  ];


}
