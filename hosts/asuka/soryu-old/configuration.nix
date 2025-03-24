# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./tahoe.nix
      ./gnunet-module.nix
      ./wack.nix
      ./ai.nix
    ];

#  programs.adb.enable = true;

  systemd.enableEmergencyMode = false;

  networking.hostName = "soryu";
  networking.extraHosts = ''
    127.0.0.1 modules-cdn.eac-prod.on.epicgames.com #Star Citizen EAC workaround
  '';

  # Star Citizen resource limits
  boot.kernel.sysctl = {
    "vm.max_map_count" = 16777216;
    "fs.file-max" = 524288;
  };

  zramSwap = {
    enable = true;
    memoryMax = 96 * 1024 * 1024 * 1024;  # 96 GB ZRAM
  };

  disabledModules = [
    "services/network-filesystems/tahoe.nix"
    "services/networking/gnunet.nix"
  ];

  services.resolved.enable = true;
  services.resolved.dnssec = "false";

  services.gnome.gnome-keyring.enable = true;

#  services.tahoe.nodes.pvv-danio-desktop = {
#    settings = {
#      storage.enabled = true;
#      storage.storage_dir = "/mnt/human/tahoe-lafs/pvv";
#      client."shares.total" = 10;
#      client."shares.needed" = 4;
#      client."shares.happy" = 1;
#    };
#  };


#  services.gnunet = {
#    enable = true;
#    package = pkgs.callPackage ./gnunet.nix { };
#    settings = {
#      hostlist = {
#        OPTIONS = "-b -e";
#        SERVERS = "http://v15.gnunet.org/hostlist https://gnunet.io/hostlist";
#      };
##      nat = {
##        BEHIND_NAT = "YES";
##        ENABLE_UPNP = "NO";
##        DISABLEV6 = "YES";
##      };
#       ats = {
#         WAN_QUOTA_IN = "unlimited";
#         WAN_QUOTA_OUT = "unlimited";
#       };
#    };
#  };

  ids.gids.gnunetdns = 327;


  # services.gnunet = {
  #   enable = true;
  #   extraOptions = ''
  #     [hostlist]
  #     OPTIONS = -b -e
  #     SERVERS = http://v11.gnunet.org:58080/
  #     HTTPPORT = 8080
  #     HOSTLISTFILE = $SERVICEHOME/hostlists.file
  #     [arm]
  #     START_SYSTEM_SERVICES = YES
  #     START_USER_SERVICES = NO
  #   '';
  # };


  services.murmur = {
    enable = true;
    # registerName = "DODSORFAS";
    welcometext = "Dans PC at singsaker smh backup mumble server";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.kernelParams = ["radeon.cik_support=0" "amdgpu.cik_support=1"];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelModules = [ "kvm-intel" ];


  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = false; # Open ports in the firewall for Source Dedicated Server
  };

  nixpkgs.config = {
    allowUnfree = true;
  };

  services.tailscale.enable = true;

  networking.firewall.interfaces."tailscale0" = let
    all = { from = 0; to = 65535; };
  in {
    allowedUDPPortRanges = [ all ];
    allowedTCPPortRanges = [ all ];
  };

  # Select internationalisation properties.
  console.keyMap = "no-latin1";

  time.timeZone = "Europe/Oslo";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
   wget vim git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 8000 6007 5001 config.services.murmur.port ];
  networking.firewall.allowedUDPPorts = [ 5001 21977 config.services.murmur.port ];

  

  # Enable CUPS to print documents.
  # services.printing.enable = true;

    
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };



#  systemd.tmpfiles.rules = [
#    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
#  ];

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    libva
  ];
  hardware.amdgpu.opencl.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.xkb.layout = "no";
  # services.xserver.xkbOptions = "eurosign:e";

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.videoDrivers = ["amdgpu"];



  programs.zsh.enable = true;

  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;


#  networking.nameservers = lib.mkForce [ "192.168.0.25" ];



#  services.ipfs.enable = true;
#  services.ipfs.gatewayAddress = "/ip4/127.0.0.1/tcp/5002";

  nix.trustedUsers = [ "dan" ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  users.users.dan = {
    isNormalUser = true;
    uid = 1001;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "gnunet" "libvirtd" ];
    initialPassword = "Abc123";
  };

  programs.dconf.enable = true;
  services.dbus.packages = with pkgs; [ dconf ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.03"; # Did you read the comment?

}

