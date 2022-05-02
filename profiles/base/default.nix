{ config, lib, pkgs, ... }:

let
  cfg = config.profiles.base;
in {

  options.machine = {
    name = lib.mkOption {
      type = lib.types.str;
    };
    eth = lib.mkOption {};
    wlan = lib.mkOption {};
    secondary-fs = lib.mkOption {
      type = lib.types.str;
      default = "$HOME";
    };
  };

  options.profiles.base = {
    enable = lib.mkEnableOption "The base profile, should be always enabled";
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      #libguestfs
      #ansible
      #nixops

      nix-output-monitor
      nix-top
      nix-index
      unstable.comma

      ldns
      mtr

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
      exa
      ripgrep
    
      mkvtoolnix
#      unstable.youtubeDL
      ffmpeg-full
    ] ++ lib.optionals config.profiles.gui.enable [
#      virtmanager
#      virt-viewer

     thunderbird

      mpv
      sxiv

      mumble
    
      #dan.rank_photos


      dolphin plasma5Packages.dolphin-plugins
      ffmpegthumbs
      plasma5Packages.kdegraphics-thumbnailers
      plasma5Packages.kio plasma5Packages.kio-extras
      krename
      konsole # https://bugs.kde.org/show_bug.cgi?id=407990 reeee

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
      profiles = {
        daniel = {
          settings = {
            "browser.startup.homepage" = "https://nixos.org";
          };
          bookmarks = {
            "NixOS Options" = {
              keyword = "no";
              url = "https://search.nixos.org/options?query=%s";
            };
            "NixOS Packages" = {
              keyword = "np";
              url = "https://search.nixos.org/packages?query=%s";
            };
            "Home-Manager Options" = {
              keyword = "hm";
              url = "https://rycee.gitlab.io/home-manager/options.html#opt-%s";
            };
          };
        };
      };
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [ bitwarden cookies-txt https-everywhere metamask no-pdf-download sponsorblock ublock-origin  ];
    };

    programs.obs-studio.enable = config.profiles.gui.enable;


    programs.git = {
      enable = true;
      userEmail = "daniel.olsen99@gmail.com";
      userName = "Daniel Olsen";
      extraConfig = {
         pull.rebase = true;
      };
      delta.enable = true;
    };


    programs.ssh = {
      enable = true;
      matchBlocks = {
        "lilith" = {
          hostname = "lilith.d.d.dodsorf.as";
          user = "dandellion";
        };
        "desktop" = {
          hostname = "10.42.42.10";
          user = "dan";
        };
        "laptop" = {
          hostname = "10.42.42.13";
          user = "daniel";
        };
        "pvv.ntnu.no" = {
          user = "danio";
        };
        "*.pvv.ntnu.no" = {
          user = "danio";
        };
        "gitlab.stud.idi.ntnu.no" = {
          proxyJump = "login.pvv.ntnu.no";
        };
        "workshop" = {
          user = "student";
          hostname = "129.241.99.15";
          proxyJump = "hildring.pvv.ntnu.no";
        };
      };
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

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "image/png" = [ "sxiv.desktop" "gimp.desktop" ];
        "text/plain" = [ "gedit.desktop" "kakoune.desktop" "code.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
      };
      associations.removed = {
        "text/plain" = [ "writer.desktop" ];
      };
    };

    fonts.fontconfig.enable = config.profiles.gui.enable;
  };
}
