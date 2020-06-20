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
      profiles.dan = {
        id = 0;
        isDefault = true;
        userChrome = ''
          
       /*
       *---------------------------------------*
       |  Dotfiles  -  firefox/userChrome.css  |
       *---------------------------------------*
       */


       @namespace url(http://www.mozilla.org/keymaster/gatekeeper/there.is.only.xul);


       /* === General === */

       /* Configure the look of the url field */
       #urlbar {
         border: none !important;
         background: transparent !important;
         margin-left: 10px !important;
         border-radius: 0px !important;
         height: 0px;
         font-size: 15px;
         font-family: Share\-TechMono;
       }

       /* Configure the look of the nav bar */
       #nav-bar {
         border-top: none !important;
         background: #ffffff !important;
       }

       /* Remove the reload button */
       #urlbar-reload-button {
         display: none !important;
       }

       /* Remove back and forward buttons */
       #nav-bar  #back-button > .toolbarbutton-icon {
         display: none !important;
       }

        #forward-button {
          display: none !important;
        }


        /* === Tabbar === */

        /* Set the height of the tabbar */
        #TabsToolbar {
          margin-top: -3px !important;
          margin-bottom: -2px !important;
          font-size: 15px;
          font-family: Share\-TechMono;
        }

        /* Set the background of the tabbar */
        .tabbrowser-tabs  {
    /*    background-color: #cbe4ec !important;*/
          background-color: #B0B0B0 !important;
        }

        /* Configure the look of normal tabs */
        .tabbrowser-tab {
          color: #505050 !important;
      /*    background-color: #cbe4ec !important;*/
          background-color: #B0B0B0 !important;
        }

        /* Configure the look of the selected tab */
        .tabbrowser-tab[selected] {
          color: #505050 !important;
          background: #ffffff !important;
        }

        /* Configure the look of the hovered-over tab */
        .tabbrowser-tab:hover:not([selected]) {
          color: #303030 !important;
          background-color: #ffffff !important;
        }

        /* Make the sides of tabs straight, not curvy */
        .tab-background {
          background: transparent !important;
        }
        #TabsToolbar .tab-background-middle {
          background: transparent !important;
          margin: -12px 0px !important;
        }
        .tab-background-start,
        .tab-background-end {
          display: none !important;
        }

        /* Remove tab separators */
        .tabbrowser-tab::before{
          display:none !important;
        }
        .tabbrowser-tab::after{
          display:none !important;
        }

        /* Don't display the new tab button 
        .tabs-newtab-button,
        #new-tab-button {
          display: none !important;
        }*/

        /* Don't display the close tab button 
        .tabbrowser-tab .close-icon {
          display: none !important;
        }*/

        /* Don't display the alltabs button (appears when not all tabs can be fitted) */
        #alltabs-button {
          display: none !important;
        }
        '';
      };
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
