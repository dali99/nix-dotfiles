{ config, lib, pkgs, inputs, ... }:

{

  networking.firewall.allowedTCPPorts = [ 1337 ];

  networking.nat.forwardPorts = [
    {
      destination = "${config.containers.ireul.hostAddress}:1337";
      proto = "tcp";
      sourcePort = 1337;
    }
  ];

  containers.ireul = {
    bindMounts."/wordlists" = {
      hostPath = "/mnt/human/wordlists";
      isReadOnly = false;
    };
    privateNetwork = true;
    hostAddress = "192.168.10.1";
    localAddress = "192.168.10.2";
    forwardPorts = [
      { containerPort = 1337;
        hostPort = 1337;
        protocol = "tcp";
      }
    ];

    bindMounts."/dev/dri" = {
      hostPath = "/dev/dri";
      isReadOnly = false;
    };
    bindMounts."/dev/kfd" = {          
      hostPath = "/dev/kfd";
      isReadOnly = false;
    };
    bindMounts."/run/opengl-driver" = {          
      hostPath = "/run/opengl-driver";
      isReadOnly = false;
    };

    allowedDevices = [
      { node = "/dev/dri/card0"; modifier = "rw"; }
      { node = "/dev/dri/renderD128"; modifier = "rw"; }
      { node = "/dev/kfd"; modifier = "rw"; }
    ];

    config = { config, pkgs, ... }: {
      services.openssh.enable = true;
      services.openssh.ports = [ 1337 ];

      environment.systemPackages = with pkgs; [
        hashcat
        hashcat-utils
        john

        kitty.terminfo
      ];

      users.groups.video.members = builtins.attrNames config.users.users;


      programs.zsh.enable = true;
      imports = [ (inputs.wack-server-conf + /users/default.nix) ];

      system.stateVersion = "23.05";
    };
  };

}

