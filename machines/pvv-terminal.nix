{ config, lib, pkgs, ... }:
{
  imports = [ ../profiles ];

  machine = {
    name = "PVV Terminal";
    eth = null;
    wlan = null;
    secondary-fs = null;
  };
  profiles.base.enable = true;
  profiles.gui.enable = true;
  profiles.non-nixos.enable = true;
  profiles.xsession.enable = true;
  profiles.zsh.enable = true;

  profiles.audio.fancy = false;

  profiles.games.enable = false;

  services.polybar.config."module/uquota" = {
    type = "custom/script";
    exec-if = "which uquota";
    exec = "" + pkgs.writers.writePerl "parse_uquota" { } ''
      my $raw = `uquota`;
      if ( $raw =~ /Du har brukt (\d+(?:[KMGT]iB)) av (\d+(?:[KMGT]iB)), eller (\d+)/ )
      {
          print $3 . "%\n";
      }
    '';
    interval = 10;
    format = "ﴥ <label>";
  };

  programs.home-manager = {
    enable = true;
    path = "https://github.com/rycee/home-manager/archive/release-21.11.tar.gz";
  };
}
