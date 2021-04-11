{pkgs, config, lib, ...}:

{
  config = lib.mkIf config.profiles.xsession.enable {
    home.packages = [
      pkgs.jack2
    ] ++ lib.optionals config.profiles.gui.enable [
      pkgs.pavucontrol
      pkgs.qjackctl
    ];

#    home.file.pulse = {
#      target = ".config/pulse/client.conf";
#      text = ''
#        daemon-binary=/var/run/current-system/sw/bin/pulseaudio
#      '';
#    };
  };
}
