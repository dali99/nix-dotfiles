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
      #libguestfs
      #ansible
      #nixops
      ldns

      lsof

      htop

      file
      tmux
    
      unzip
      p7zip
      parallel
      sshfs
      jq

      ncdu

      bat
      ripgrep
    
      mkvtoolnix
#      unstable.youtubeDL
      ffmpeg-full
    
    ] ++ lib.optionals config.profiles.gui.enable [
#      virtmanager
#      virt-viewer

      mpv
      sxiv
      unstable.hydrus
      spotify
    
      mumble
    
      dolphin
      konsole
      krename
      #kdeApplications.dolphin-plugins
      ffmpegthumbs
      #kdeApplications.kdegraphics-thumbnailers
      #kdeFrameworks.kded
      #kdeFrameworks.kio
      #kdeApplications.kio-extras

      #dan.rank_photos

#      ***REMOVED***

      gnome3.gedit
      unstable.vscode
#      texlive.combined.scheme-full
#      kile
      libreoffice
    
      gimp
#      krita
#      inkscape
#      digikam
#      godot
#      blender
#      audacity
#      mixxx
#      ardour
      kdenlive
      frei0r
      
      geogebra
    ];

    programs.firefox = {
      enable = config.profiles.gui.enable;

#      package = pkgs.firefox.override { extraNativeMessagingHosts = [ pkgs.dan.radical-native ]; };    
    };

    programs.obs-studio = {
      enable = config.profiles.gui.enable;
    };


    programs.git = {
      enable = true;
      userEmail = "daniel.olsen99@gmail.com";
      userName = "Daniel Olsen";
      extraConfig = {
         pull.rebase = true;
      };
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
