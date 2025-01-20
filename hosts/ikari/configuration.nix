# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];


  services.restic.backups."main" = {
    repositoryFile = "/root/restic-main-repo";
    passwordFile = "/root/restic-main-password";
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 5"
      "--keep-monthly 12"
      "--keep-yearly 2"
    ];
    paths = [
      "/var/lib"
      "/home/daniel"
    ];
    exclude = [
      "/home/*/.cache"
    
      "/home/*/.local/Trash"
      
      "/home/*/.local/share/Steam/*"
      "!/home/*/.local/share/Steam/steamapps/compatdata"

      "/home/*/.cargo"
    ];
  };


  services.postgresql.enable = true;
  services.postgresql.package = pkgs.postgresql_15;
  services.postgresql.authentication = ''
    host all all 192.168.10.0/24 md5
  '';

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      # Add additional package names here
      "nvidia-x11"
      "nvidia-settings"
      "nvidia-persistenced"

      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
    ];
  

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    modesetting.enable = true;
    nvidiaSettings = true;
    powerManagement.finegrained = false;
    open = false;
  };
  #hardware.graphics.enable = true;
  hardware.opengl.driSupport32Bit = true;


  programs.steam = {
    enable = true;
    remotePlay.openFirewall = false;
    dedicatedServer.openFirewall = false;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "ikari"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  services.tailscale.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
    useXkbConfig = true; # use xkb.options in tty.
  };


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

  services.dbus.packages = with pkgs; [ pkgs.dconf ];
  programs.dconf.enable = true;

  

  # Configure keymap in X11
  services.xserver.xkb.layout = "no";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    jack.enable = true;
  };


  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.daniel = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCp8iMOx3eTiG5AmDh2KjKcigf7xdRKn9M7iZQ4RqP0np0UN2NUbu+VAMJmkWFyi3JpxmLuhszU0F1xY+3qM3ARduy1cs89B/bBE85xlOeYhcYVmpcgPR5xduS+TuHTBzFAgp+IU7/lgxdjcJ3PH4K0ruGRcX1xrytmk/vdY8IeSk3GVWDRrRbH6brO4cCCFjX0zJ7G6hBQueTPQoOy3jrUvgpRkzZY4ZCuljXtxbuX5X/2qWAkp8ca0iTQ5FzNA5JUyj+DWeEzjIEz6GrckOdV2LjWpT9+CtOqoPZOUudE1J9mJk4snNlMQjE06It7Kr50bpwoPqnxjo7ZjlHFLezl"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.openFirewall = false;

  networking.firewall.interfaces."tailscale0" = let
    all = { from = 0; to = 65535; };
  in {
    allowedUDPPortRanges = [ all ];
    allowedTCPPortRanges = [ all ];
  };

  networking.firewall.trustedInterfaces = [ "eno1" ];

  nix.settings.trusted-users = [ "daniel" ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];



  system.stateVersion = "24.05"; # Did you read the comment?
}

