{ pkgs, config, lib, ...}:

{

  #home.file.nixoverlays = {
  #  source = ./overlays;
  #  target = ".config/nixpkgs/overlays";
  #};

  home.keyboard = {
    layout = "no-latin1";
  };

  xsession = {
    enable = true;
    windowManager = {
      i3.enable = true;
      i3.config = {
        modifier = "Mod4";
        keybindings = let modifier = "Mod4"; #xsession.windowManager.i3.config.modifier;
        in lib.mkOptionDefault {
          "${modifier}+0" = "workspace 10";
          "${modifier}+Shift+0" = "move container to workspace 10";

          "${modifier}+Tab" = "workspace next";
          "${modifier}+Shift+Tab" = "workspace prev";

          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume 0 +5%";
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume 0 -5%";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 0 toggle";
          "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute 1 toggle";

          "XF86MonBrightnessUp" = "exec --no-startup-id xbacklight -inc 5";
          "XF86MonBrightnessDown" = "exec --no-startup-id xbacklight -dec 5";

          "XF86Display" = "exec arandr";

          "Print" = "exec scrot %Y-%m-%d_$wx$h_scrot.png -z -e 'mv $f /home/daniel/Pictures/screenshots/'";
          "${modifier}+Print" = "exec scrot %Y-%m-%d_$wx$h_scrot.png -z -e 'mv $f /home/daniel/Pictures/screenshots/'";


          "${modifier}+n" = "exec dolphin";
          "${modifier}+b" = "exec firefox";
          "${modifier}+t" = "exec gedit";

          "${modifier}+Return" = lib.mkForce "exec i3-sensible-terminal -e zsh";
          "${modifier}+Shift+Return" = "exec i3-sensible-terminal -e ssh daniel@adam";
        };
      };
    };
  };
 
  services.compton = {
    enable = true;
    backend = "xrender";
  };

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

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableAutosuggestions = true;
    enableCompletion = true;
    history = {
      expireDuplicatesFirst = true;
      ignoreDups = true;
    };
    oh-my-zsh = {
      enable = true;
      custom = "\$HOME/.config/nixpkgs/nix-dotfiles/zsh/oh-my-zsh-custom";
      plugins = [
        "git"
        "sudo"
      ];
      theme = "powerlevel9k/powerlevel9k";
    };
    initExtra = ''
      POWERLEVEL9K_MODE='nerdfont-complete'

      POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon context dir newline vcs)
      POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status time)

      POWERLEVEL9K_OS_ICON_BACKGROUND="white"
      POWERLEVEL9K_OS_ICON_FOREGROUND="blue"

      POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="green"
      POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="white"
      POWERLEVEL9K_CONTEXT_SUDO_BACKGROUND="red"
      POWERLEVEL9K_CONTEXT_SUDO_FOREGROUND="white"

      POWERLEVEL9K_DIR_HOME_FOREGROUND="white"
      POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="white"
      POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="white"
      POWERLEVEL9K_SHORTEN_DIR_LENGTH=2
      POWERLEVEL9K_SHORTEN_DELIMITER=".."

      POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="↱"
      POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX="↳ "


      eval "$(ntfy shell-integration)"
      AUTO_NTFY_DONE_IGNORE="vim nano screen tmux man"
    '';
  };

  home.file.ntfy = {
    source = ./secret/ntfy.yml;
    target = ".config/ntfy/ntfy.yml";
  };

  home.file.dunst = {
    source = ./dunstrc;
    target = ".config/dunst/dunstrc";
  };

  programs.direnv = {
    enable = true;
  };

  services.nextcloud-client.enable = true;

  home.packages = [
    pkgs.gnome3.gnome-terminal
    
    pkgs.pavucontrol

    pkgs.libguestfs
    pkgs.virtmanager

    pkgs.nerdfonts
    pkgs.dejavu_fonts
    pkgs.ntfy
    pkgs.dunst

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
