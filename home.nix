{ pkgs, config, lib, ...}:

{

  #home.file.nixoverlays = {
  #  source = ./overlays;
  #  target = ".config/nixpkgs/overlays";
  #};

  imports = [ ./config/xsession/xsession.nix ];

  home.packages = [
    pkgs.libguestfs
    pkgs.virtmanager

    pkgs.steam
    pkgs.dolphinEmuMaster
    pkgs.dwarf-fortress-packages.dwarf-fortress-full
    pkgs.multimc
    pkgs.superTuxKart
#    pkgs.warsow
    
    pkgs.firefox
    pkgs.mpv
    pkgs.sxiv
    pkgs.spotify
    
    pkgs.mumble
    
    pkgs.dolphin
    pkgs.unzip

    pkgs.gnome3.gedit
    pkgs.libreoffice-fresh
    pkgs.texlive.combined.scheme-full
    pkgs.kile
    pkgs.libreoffice-unwrapped
    
    pkgs.gimp
    pkgs.krita
    pkgs.inkscape
    pkgs.godot
    pkgs.blender
    pkgs.audacity
    pkgs.mixxx
    pkgs.ardour
    pkgs.kdenlive
    pkgs.frei0r
    pkgs.ffplay
    
    pkgs.mkvtoolnix
    pkgs.ffmpeg
    
    pkgs.geogebra
  ];

  programs.obs-studio = {
    enable = true;
    plugins = [pkgs.obs-linuxbrowser];
  };


  programs.git = {
    enable = true;
    userEmail = "daniel@dodsorf.as";
    userName = "Daniel Løvbrøtte Olsen";
  };


  services.kdeconnect = {
    enable = true;
    indicator = true;
  };


  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };



  programs.home-manager = {
    enable = true;
    path = "https://github.com/rycee/home-manager/archive/master.tar.gz";
  };
}
