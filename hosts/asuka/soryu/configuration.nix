# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
#      ./wack.nix
      ./ollama.nix
      ../../common/builder.nix
    ];

  nixpkgs.config = {
    allowUnfree = true;
    rocmSupport = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot = {
    enable = true;
    netbootxyz = { enable = true; sortKey = "y_netbootxyz"; };
    edk2-uefi-shell = { enable = true; sortKey = "z_edk2-uefi-shell"; };
    extraEntries = {
      "old-soryuu.conf" = ''
        title Old Soryuu;
        efi /efi/edk2-uefi-shell/shell.efi
        options -nointerrupt -nomap -noversion HD1b65535a:\EFI\systemd\systemd-bootx64.efi
        sort-key o_soryuu-old
      '';
    };
  };

  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelPackages = pkgs.linuxPackages_latest;

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

  services.resolved.enable = true;
  services.resolved.dnssec = "false";

  services.gnome.gnome-keyring.enable = true;

  services.murmur = {
    enable = true;
    # registerName = "DODSORFAS";
    welcometext = "Dans PC at singsaker smh backup mumble server";
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
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
  networking.firewall.allowedTCPPorts = [ config.services.murmur.port ];
  networking.firewall.allowedUDPPorts = [ config.services.murmur.port ];



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

  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.graphics.extraPackages = with pkgs; [
    libva rocmPackages.clr.icd
  ];
  hardware.amdgpu.opencl.enable = true;

  systemd.tmpfiles.rules = 
  let
    rocmEnv = pkgs.symlinkJoin {
      name = "rocm-combined";
      paths = with pkgs.rocmPackages; [
        rocblas
        hipblas
        clr
      ];
    };
  in [
    "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
  ];


  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager = {
    defaultSession = "xsession";
    session = [
      { manage = "desktop";
        name = "xsession";
        start = "exec $HOME/.xsession";
      }
    ];
  };
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

  nix.trustedUsers = [ "daniel" ];
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  users.users.daniel = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "libvirtd" ];
    initialPassword = "Abc123";
  };

  programs.dconf.enable = true;
  services.dbus.packages = with pkgs; [ dconf ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "24.11"; # Did you read the comment?

}
