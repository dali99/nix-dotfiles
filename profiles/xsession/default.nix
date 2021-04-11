{ pkgs, config, lib, ... }:

let
  cfg = config.profiles.xsession;
in
{
  imports = [ ./dunstrc.nix ./terminal.nix ./audio.nix ./polybar.nix ];

  options.profiles.xsession = {
    enable = lib.mkEnableOption "Whether or not to control the xsession";
  };


  config = lib.mkIf cfg.enable {
    profiles.gui.enable = true;

    home.keyboard = {
      layout = "no-latin1";
    };

    services.random-background = {
      enable = true;
      imageDirectory = "${pkgs.dan.wallpapers}";
      interval = "30m";
    };

    services.dunst.enable = false;

    xsession = {
      enable = true;


      initExtra = ''
        export PATH="$HOME/.config/nixpkgs/nix-dotfiles/bin:$PATH"

        export XDG_CURRENT_DESKTOP=kde
        export DESKTOP_SESSION=kde

        export QT_STYLE_OVERRIDE="breeze"
      '';

      windowManager = {
        i3.enable = true;
        i3.config = {
          modifier = "Mod4";
          terminal = "kitty";
          keybindings = let modifier = config.xsession.windowManager.i3.config.modifier;
          in lib.mkOptionDefault {
            "${modifier}+0" = "workspace 10";
            "${modifier}+Shift+0" = "move container to workspace 10";

            "${modifier}+Tab" = "workspace next";
            "${modifier}+Shift+Tab" = "workspace prev";

            "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume 0 +5%";
            "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume 0 -5%";
            "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 0 toggle";
            "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute 1 toggle";

            "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +5%";
            "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 5%-";

            "XF86Display" = "exec arandr";

            "Print" = "exec scrot %Y-%m-%d_$wx$h_scrot.png -z -e 'mv $f /home/daniel/Pictures/screenshots/'";
            "${modifier}+Print" = "exec scrot /home/daniel/Pictures/Screenshots/%Y-%m-%d_$wx$h_scrot.png -z";
            "${modifier}+Shift+U" = "exec $HOME/.config/nixpkgs/nix-dotfiles/scripts/dmenuunicode";

            "${modifier}+n" = "exec dolphin";
            "${modifier}+b" = "exec firefox";
            "${modifier}+t" = "exec gedit";

            # "${modifier}+Return" = lib.mkForce "exec kitty";
            "${modifier}+Shift+Return" = "exec kitty -e ssh dandellion@lilith";
          };
          window = {
            titlebar = false;
            hideEdgeBorders = "smart";
          };
        };
      };
    };

    services.picom = {
      enable = true;
      backend = "xrender";
    };


    gtk = {
      enable = true;
      theme = {
        package = pkgs.breeze-gtk;
        name = "Breeze";
      };
      iconTheme = {
        package = pkgs.breeze-icons;
        name = "breeze";
      };
    };
    qt = {
      enable = true;
      #useGtkTheme = true;
      platformTheme = "gtk";
    };

    home.packages = [
      pkgs.brightnessctl
      pkgs.xorg.xkill
      pkgs.arandr

      pkgs.dunst
      pkgs.libnotify

      pkgs.dmenu

      pkgs.scrot
      pkgs.neofetch
      #pkgs.dan.colors
      pkgs.xclip

      pkgs.dejavu_fonts

      pkgs.source-code-pro

      pkgs.breeze-qt5
      pkgs.breeze-icons
    ];
  };
}
