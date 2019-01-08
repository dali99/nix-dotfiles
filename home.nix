{ pkgs, config, lib, ...}:

{

  #home.file.nixoverlays = {
  #  source = ./overlays;
  #  target = ".config/nixpkgs/overlays";
  #};

  imports = [ ./config/xsession.nix ./config/zsh/zsh.nix ./config/dunstrc.nix ];

  programs.urxvt = {
    enable = true;
    fonts = [ "xft:DejaVu Sans Mono Nerd Font:size=12" ];
    scroll.bar.enable = false;
    shading = 20;
    extraConfig = {
      "foreground" = "#cccccc";
      "tintColor" = "white";
      "depth" = 32;
      "background" = "rgba:0000/0000/0200/c800";
#      "color0" = "#000000";
#      "color1" = "#9e1828";
#      "color2" = "#aece92";
#      "color3" = "#968a38";
#      "color4" = "#414171";
#      "color5" = "#963c59";
#      "color6" = "#418179";
#      "color7" = "#bebebe";
#      "color8" = "#666666";
#      "color9" = "#cf6171";
#      "color10" = "#c5f779";
#      "color11" = "#fff796";
#      "color12" = "#4186be";
#      "color13" = "#cf9ebe";
#      "color14" = "#71bebe";
#      "color15" = "#ffffff";
#      "buffered" = "false";
    };
  };

  programs.direnv = {
    enable = true;
  };

  home.packages = [
    pkgs.gnome3.gnome-terminal
    
    pkgs.pavucontrol

    pkgs.libguestfs
    pkgs.virtmanager

    pkgs.dejavu_fonts
    

    pkgs.scrot
    pkgs.xorg.xbacklight

    pkgs.steam
    pkgs.dolphinEmuMaster
    pkgs.dwarf-fortress-packages.dwarf-fortress-full
    pkgs.multimc
    pkgs.superTuxKart
#    pkgs.warsow
    
    pkgs.firefox
    pkgs.mpv
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

#  programs.htop = {


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
