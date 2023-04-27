{ pkgs, config, lib, ... }:

let
  cfg = config.profiles.xsession;
  non-nixos = config.profiles.non-nixos;
  mkGL = program: "${lib.strings.optionalString non-nixos.enable "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL "}${program}";
  execScope = program: "exec bash -c \"systemd-run --user --scope --unit='app-i3-exec-$RANDOM' -p CollectMode=inactive-or-failed -p MemoryHigh=85% -p MemoryMax=92% -p MemorySwapMax=5G -p MemoryAccounting=true \"${program}\"\"";
in
{
  imports = [ ./dunstrc.nix ./terminal.nix ./polybar.nix ];

  options.profiles.xsession = {
    enable = lib.mkEnableOption "Whether or not to control the xsession";
  };


  config = lib.mkIf cfg.enable {
    profiles.gui.enable = true;

    systemd.user.slices.app.Slice = {
      MemoryHigh="90%";
      MemoryMax="94%";
      MemorySwapMax="8G";
      CPUQuota="${toString ((config.machine.cores - 1)*100)}%";
      MemoryAccounting = true;
    };

    home.keyboard = {
      layout = "no";
      variant = "nodeadkeys";
    };

    services.random-background = {
      enable = false;
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
          terminal = "${pkgs.kitty}/bin/kitty";
          keybindings = let
            modifier = config.xsession.windowManager.i3.config.modifier;
            dmenu = if config.machine.systemd then "${../../scripts/dmenu_run_systemd}" else "dmenu_run";
          in lib.mkOptionDefault {
            "${modifier}+0" = "workspace 10";
            "${modifier}+Shift+0" = "move container to workspace 10";

            "${modifier}+Tab" = "workspace next";
            "${modifier}+Shift+Tab" = "workspace prev";

            "XF86AudioRaiseVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 +5%";
            "XF86AudioLowerVolume" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-volume 0 -5%";
            "XF86AudioMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-sink-mute 0 toggle";
            "XF86AudioMicMute" = "exec --no-startup-id ${pkgs.pulseaudio}/bin/pactl set-source-mute 1 toggle";

            "XF86MonBrightnessUp" = "exec --no-startup-id brightnessctl set +5%";
            "XF86MonBrightnessDown" = "exec --no-startup-id brightnessctl set 5%-";

            "Print" = "exec scrot %Y-%m-%d_$wx$h_scrot.png -z -e 'mv $f /home/daniel/Pictures/screenshots/'";
            "${modifier}+Print" = "exec scrot /home/daniel/Pictures/Screenshots/%Y-%m-%d_$wx$h_scrot.png -z";

            "${modifier}+l" = "exec ${pkgs.writers.writeBash "hello_world" ''
              dunstctl set-paused true
              ${pkgs.i3lock}/bin/i3lock -n -i ~/images/wallpapers/locked.png
              dunstctl set-paused false
            ''}";

            "XF86Display" = "exec arandr";

            "${modifier}+Shift+U" = "exec $HOME/.config/nixpkgs/nix-dotfiles/scripts/dmenuunicode";
            "${modifier}+Shift+s" = "exec $HOME/.config/nixpkgs/nix-dotfiles/scripts/dmenuaudio";

            "${modifier}+d" = "exec ${dmenu}";

            "${modifier}+n" = execScope "dolphin";
            "${modifier}+b" = execScope "firefox";
            "${modifier}+t" = execScope "gedit";

            "${modifier}+Return" = execScope "kitty";
            "${modifier}+Shift+Return" = execScope "kitty -e ssh dandellion@lilith";
          };
          startup = [
            { 
              command = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
              always = false;
              #notification = false;
            }
          ];
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
      enable = false;
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

    xsession.windowManager.command = lib.mkIf non-nixos.enable (lib.mkForce "${pkgs.nixgl.auto.nixGLDefault}/bin/nixGL ${config.xsession.windowManager.i3.package}/bin/i3");

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
