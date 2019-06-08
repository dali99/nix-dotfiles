{pkgs, config, lib, ...}:

{

  home.packages = [
    pkgs.jack2
    pkgs.qjackctl
  ];

  home.file.pulse = {
    target = ".config/pulse/client.conf";
    text = ''
daemon-binary=/var/run/current-system/sw/bin/pulseaudio
'';
  };

}
