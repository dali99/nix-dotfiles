{ config, lib, pkgs, ... }:

let
  cfg = config.profiles.base;
in {

  options.machine = {
    name = lib.mkOption {
      type = "str";
    };
    eth = lib.mkOption {};
  };

  options.profiles.base = {
    enable = lib.mkEnableOption "The base profile, should be always enabled";
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      libguestfs
      virtmanager
      virt-viewer
      ansible
      nixops
      ldns

      htop

      file
      tmux

#      danstable.mangohud

      steam
      dolphinEmuMaster
      dwarf-fortress-packages.dwarf-fortress-full
      multimc
      superTuxKart
#      warsow
      minetest
    
      mpv
      sxiv
      spotify
    
      mumble
    
      dolphin
      krename
      kdeApplications.dolphin-plugins
      ffmpegthumbs
      kdeApplications.kdegraphics-thumbnailers
      kdeFrameworks.kded
      kdeFrameworks.kio
      kdeApplications.kio-extras
    
      unzip
      p7zip
      parallel
      sshfs
      jq

      ncdu

      bat
      ripgrep
    
      dan.rank_photos

#      ***REMOVED***

      dan.photini

      gnome3.gedit
      unstable.vscode
      texlive.combined.scheme-full
      kile
      libreoffice-unwrapped
    
      gimp
      krita
      inkscape
      digikam
      godot
      blender
      audacity
      mixxx
      ardour
      kdenlive
      frei0r
    
      mkvtoolnix
      unstable.youtubeDL
      ffmpeg-full
    
      geogebra
    ];

    programs.firefox = {
      enable = true;

      package = pkgs.firefox.override { extraNativeMessagingHosts = [ pkgs.dan.radical-native ]; };    
    };

    programs.obs-studio = {
      enable = true;
    };


    programs.git = {
      enable = true;
      userEmail = "daniel.olsen99@gmail.com";
      userName = "Daniel Olsen";

#      delta.enable = true;
    
    };


#    services.kdeconnect = {
#      enable = true;
#      indicator = true;
#    };


    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    fonts.fontconfig.enable = true;
  };
}
