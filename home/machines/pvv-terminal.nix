{ config, lib, pkgs, overlays, ... }:
{
  nixpkgs.overlays = overlays;
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  imports = [ ../profiles ];

  machine = {
    name = "PVV Terminal";
    eth = null;
    wlan = null;
    secondary-fs = null;
  };

  profiles.base.enable = true;
  profiles.base.plus = false;
  profiles.gui.enable = true;
  profiles.non-nixos.enable = true;
  profiles.xsession.enable = true;
  profiles.zsh.enable = true;

  profiles.audio.fancy = false;

  profiles.games.enable = false;

  services.polybar.config."module/uquota" = {
    type = "custom/script";
    exec-if = "test -f /usr/local/bin/uquota";
    exec = "" + pkgs.writers.writePerl "parse_uquota" { } ''
      my $raw = `/usr/local/bin/uquota`;
      if ( $raw =~ /Du har brukt (\d+(?:[KMGT]iB)) av (\d+(?:[KMGT]iB)), eller (\d+)/ )
      {
          print $3 . "%\n";
      }
    '';
    interval = 10;
    format = "ﴥ <label>";
  };
}
