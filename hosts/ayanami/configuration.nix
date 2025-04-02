#n Edit this configuration file to define what should be installed on your system.  
# Help is available in the configuration.nix(5) man page and in the NixOS manual 
# (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  networking.hosts = {
   # "10.10.111.103" = [ "snowbell.htb" "legacy.snowbell.htb" "management.snowbell.htb" ];
  };

  services.restic.backups."main" = {
    repositoryFile = "/root/restic-main-repo";
    passwordFile = "/root/restic-main-password";
    pruneOpts = [
      "--keep-last 2"
      "--keep-within 3d"
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 5"
    ];
    paths = [
      "/home/daniel"
      "/var/lib"
    ];
    exclude = [
      "/home/*/.cache"

      "/home/*/.local/share/Trash"

      "/home/*/.cargo"

      "/home/*/.local/share/Steam/*"
      "!/home/*/.local/share/Steam/compatdata"

      "/home/*/mnt"
    ];
    extraBackupArgs = [
      "--one-file-system"
    ];
  };

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  virtualisation.podman.enable = true;
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;

  programs.wireshark.enable = true;
  programs.wireshark.package = pkgs.wireshark;

  services.mysql.enable = true;
  services.mysql.package = pkgs.mariadb;
  services.mysql.settings.mysqld = {
    bind-address = "127.0.0.1";
    port = 3306;
  };
  services.mysql.ensureUsers = [
    {
      name = "daniel";
      ensurePermissions = {
        "lab1.*" = "ALL PRIVILEGES";
        "lab2.*" = "ALL PRIVILEGES";
        "lab3.*" = "ALL PRIVILEGES";
        "lab4.*" = "ALL PRIVILEGES";
        "lab5.*" = "ALL PRIVILEGES";
      };
    }
  ];

  # services.create_ap.enable = false;
  # services.create_ap.settings = {
  #   INTERNET_IFACE = "enp0s31f6";
  #   PASSPHRASE = "12345678";
  #   SSID = "DOTA2ERBEST";
  #   WIFI_IFACE = "wlp5s0";
  #   MAC_FILTER = 0;
  #   HIDDEN = 0;
  # };

  boot.kernelModules = [ "v4l2loopback" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ayanami"; # Define your hostname.
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  
  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  services.tailscale.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = false;
  networking.interfaces.wlp5s0.useDHCP = false;

  services.avahi.enable = false;

  # services.atftpd = {
  #   enable = false;
  # };

  # Select internationalisation properties.
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" "nb_NO.UTF-8/UTF-8" ];
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "nb_NO.UTF-8";
    LC_PAPER = "nb_NO.UTF-8";
    LC_NAME = "nb_NO.UTF-8";
    LC_ADDRESS = "nb_NO.UTF-8";
    LC_TELEPHONE = "nb_NO.UTF-8";
    LC_MEASUREMENT = "nb_NO.UTF-8";
    LC_IDENTIFICATION = "nb_NO.UTF-8";
};
  console = {
    font = "Lat2-Terminus16";
    keyMap = "no-latin1";
  };

  services.xserver.displayManager.lightdm.enable = true;
  services.displayManager.defaultSession = "xsession";
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.displayManager = {
    session = [
      {
        manage = "desktop";
        name = "xsession";
        start = "exec $HOME/.xsession";
      }
    ];
  };

  # Disable cups we will just not print anything :))
  services.printing.enable = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages = with pkgs; [ libva ];

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
  services.xserver.xkb.layout = "no";


  programs.zsh.enable = true;


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.daniel = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" "wireshark" "libvirtd" ];
  };

  environment.systemPackages = with pkgs; [
    vim
    git
    wget
    virt-manager
    podman-compose
  ];


  services.dbus.packages = with pkgs; [ pkgs.dconf ];

  services.openssh.enable = true;
  services.openssh.openFirewall = false;

  networking.firewall.interfaces."tailscale0" = let
    all = { from = 0; to = 65535; };
  in {
    allowedUDPPortRanges = [ all ];
    allowedTCPPortRanges = [ all ];
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 69 8010 9090 ];
  networking.firewall.allowedUDPPorts = [ 69 8010 9090 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  nix.settings.trusted-users = [ "daniel" ];

  nix.buildMachines = [
    { hostName = "soryu";
      system = "x86_64-linux";
      maxJobs = 16;
      supportedFeatures = [ "big-parallel" ];
      speedFactor = 66317;
    }
    # { hostName = "bob.pvv.ntnu.no";
    #   system = "x86_64-linux";
    #   maxJobs = 12;
    #   supportedFeatures = [ "big-parallel" ];
    #   speedFactor = 129270;
    # }
    # { hostName = "bolle.pbsds.net";
    #   system = "x86_64-linux";
    #   maxJobs = 6;
    #   speedFactor = 12857;
    # }
    # { hostName = "garp.pbsds.net";
    #   system = "x86_64-linux";
    #   maxJobs = 4;
    #   # i7-6700
    #   speedFactor = 8088;
    # }
    # { hostName = "lilith";
    #   system = "x86_64-linux";
    #   maxJobs = 6;
    #   #speedFactor = 13199;
    #   speedFactor = 6000;
    # }
    # {
    #   hostName = "isvegg.pvv.ntnu.no";
    #   system = "x86_64-linux";
    #   maxJobs = 4;
    #   speedFactor = 4961;
    #   supportedFeatures = [ "big-parallel" ];
    #   mandatoryFeatures = [ ];
    # }
  ];
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
    experimental-features = nix-command flakes impure-derivations ca-derivations
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}

