{ pkgs, config, lib, ...}:

{
  #home.file.nixoverlays = {
  #  source = ./overlays;
  #  target = ".config/nixpkgs/overlays";
  #};

  imports = [ 
    ./config/xsession/xsession.nix
    ./config/computer/laptop.nix
  ];

  home.packages = with pkgs; [
    libguestfs
    virtmanager
    virt-viewer
    ansible
    nixops
    ldns

#    danstable.mangohud

    unstable.steam
    dolphinEmuMaster
    dwarf-fortress-packages.dwarf-fortress-full
    multimc
    superTuxKart
#    warsow
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

#    ***REMOVED***

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
    userEmail = "daniel@dodsorf.as";
    userName = "Daniel Løvbrøtte Olsen";
  };


#  services.kdeconnect = {
#    enable = true;
#    indicator = true;
#  };


  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };



  programs.home-manager = {
    enable = true;
    path = "https://github.com/rycee/home-manager/archive/release-19.09.tar.gz";
  };
}
