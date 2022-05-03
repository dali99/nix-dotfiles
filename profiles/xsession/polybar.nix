{ pkgs, config, lib, ... }:

let
  cfg = config.profiles.xsession;
in
{
  config = lib.mkIf cfg.enable {
    xsession.windowManager.i3.config = {
      bars = [];
      startup = [
        { command = "systemctl --user restart polybar"; always = true; notification = false; }
      ];
    };
    services.polybar = {
      enable = true;
      package = pkgs.polybar.override {
        i3Support = true;
      };
      script = "polybar bot &";
      config = {
        "colors" = {
          background = "#B2000000";
          background-alt = "#444";
          foreground = "#dfdfdf";
          foreground-alt = "#BBB";
          primary = "#ffb52a";
          secondary = "#e60053";
          alert = "#bd2c40";
        };
        "bar/bot" = {
          bottom = true;
          width = "100%";
          height = 27;

          font-0 = "MesloLGS NF:fontformat=truetype:pixelsize=11;1";
          font-1 = "Kozuka Mincho Pro:pixelsize=11;1";

          background = "\${colors.background}";
          foreground = "\${colors.foreground}";

          padding-left = "0";
          padding-right = "2";

          module-margin-left = "1";
          module-margin-right = "2";

          modules-left = "i3 title";
          modules-right = "minecraft wlan eth filesystem uquota cpu memory battery date";
        };

        "module/i3" = {
          type = "internal/i3";
          format = "<label-state> <label-mode>";
          scroll-up = "i3wm-wsnext";
          scroll-down = "i3wm-wsprev";

          label-mode-padding = "0";
          label-mode-foreground = "#000";
          label-mode-background = "\${colors.primary}";

          label-focused = "%index%";
          label-focused-background = "\${colors.background-alt}";
          label-focused-underline= "\${colors.primary}";
          label-focused-padding = "1";

          label-unfocused = "%index%";
          label-unfocused-padding = "1";

          label-visible = "%index%";
          label-visible-background = "\${self.label-focused-background}";
          label-visible-underline = "\${self.label-focused-underline}";
          label-visible-padding = "\${self.label-focused-padding}";

          label-urgent = "%index%";
          label-urgent-background = "\${colors.alert}";
          label-urgent-padding = "1";

        };
        "module/title" = {
          type = "internal/xwindow";
        };
        "module/wlan" = lib.mkIf (config.machine.wlan != null) {
          type = "internal/network";
          interface = config.machine.wlan;
          interval = "3.0";

          format-connected = "<ramp-signal> <label-connected>";
          format-connected-underline = "#9f78e1";
          label-connected = "(%signal%% on %essid%) %local_ip%";

          format-disconnected = "";
          
          ramp-signal-0 = "";
          ramp-signal-1 = "";
          ramp-signal-2 = "";
          ramp-signal-3 = "";
          ramp-signal-4 = "";
          ramp-signal-foreground = "\${colors.foreground-alt}";
        }; 
        "module/eth" = lib.mkIf (config.machine.eth != null)
           {
             type = "internal/network";
             interface = "${config.machine.eth}";
             interval = "3.0";

             format-connected-underline = "#55aa55";
             format-connected-prefix = " ";
             format-connected-prefix-foreground = "\${colors.foreground-alt}";
             label-connected = "%local_ip%";

             format-disconnected = "";
           };
        "module/filesystem" = {
          type = "internal/fs";
          interval = 25;

          mount-0 = "/";
          mount-1 = lib.mkIf (config.machine.secondary-fs != null) config.machine.secondary-fs;

          label-mounted = "%{F#0a81f5}%mountpoint%%{F-}: %free%";
          label-unmounted = "%mountpoint% not mounted";
          label-unmounted-foreground = "\${colors.foreground-alt}";
        };
        "module/cpu" = {
          type = "internal/cpu";
          interval = 2;
          format-prefix = " ";
          format-prefix-foreground = "\${colors.foreground-alt}";
          format-underline = "#f90000";
          label = "%percentage:2%%";
        };
        "module/memory" = {
          type = "internal/memory";
          interval = "2";
          format-prefix = " ";
          format-prefix-foreground = "\${colors.foreground-alt}";
          format-underline = "#4bffdc";
          label = "%percentage_used%%";
        };
        "module/battery" = {
          type = "internal/battery";
          battery = "BAT0";
          adapter = "AC";

          format-charging = "<animation-charging> <label-charging>";
          format-charging-underline = "#ffb52a";

          format-discharging = "<animation-discharging> <label-discharging>";
          format-discharging-underline = "\${self.format-charging-underline}";

          format-full-prefix-foreground = "\${colors.foreground-alt}";
          format-full-underline = "\${self.format-charging-underline}";

          ramp-capacity-foreground = "\${colors.foreground-alt}";

          format-full-prefix = " ";
          
          ramp-capacity-0 = "";
          ramp-capacity-1 = "";
          ramp-capacity-2 = "";
          
          animation-charging-0 = "";
          animation-charging-1 = "";
          animation-charging-2 = "";
          animation-charging-foreground = "\${colors.foreground-alt}";
          animation-charging-framerate = "750";

          animation-discharging-0 = "";
          animation-discharging-1 = "";
          animation-discharging-2 = "";
          animation-discharging-foreground = "\${colors.foreground-alt}";
          animation-discharging-framerate = "750";
        };
        "module/date" = {
          type = "internal/date";
          internal = 5;
          date = "%Y-%m-%d";
          time = "%H:%M:%S";
          label = "%date% %time%";
        };

        "module/minecraft" = {
          type = "custom/script";
          exec = "" + pkgs.writers.writePython3 "minecraft_status" { libraries = [ pkgs.python3.pkgs.mcstatus ]; flakeIgnore = [ "E722" ]; } ''
            from mcstatus import MinecraftServer as JavaServer
            pvv = JavaServer.lookup("minecraft.pvv.ntnu.no")
            dods = JavaServer.lookup("mc.dodsorf.as")

            try:
                pvv_status = pvv.status()
                dods_status = dods.status()
            except:
                pass

            result = ""
            try:
                if pvv_status.players.online > 0:
                    result += ("P" + str(pvv_status.players.online))
                if dods_status > 0:
                    result += ("D" + str(pvv_status.players.online))
            except:
                pass
            print(result)
          '';
          click-left = "" + pkgs.writers.writePython3 "minecraft_status" { libraries = with pkgs.python3.pkgs; [ mcstatus notify2 ]; flakeIgnore = [ "E722" ]; } ''
            from mcstatus import MinecraftServer as JavaServer
            import notify2

            pvv = JavaServer.lookup("minecraft.pvv.ntnu.no")
            dods = JavaServer.lookup("mc.dodsorf.as")

            pvv_status = None
            dods_status = None

            try:
                pvv_status = pvv.status()
                dods_status = dods.status()
            except:
                pass

            result = ""
            if pvv_status is not None:
                result += "PVV: "
                for player in pvv_status.players.sample:
                    result += player.name
                result += "\n"
            if dods_status is not None:
                result += "DODS: "
                for player in dods_status.players.sample:
                    result += player.name
                result += "\n"

            notify2.init('Minecraft Server Status')
            n = notify2.Notification("Minecraft Server Status", result)
            n.show()
          '';
          interval = 10;
          format = " <label>";
        };
      };
    };
  };
}

