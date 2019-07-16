# Needed for screeps
# https://github.com/NixOS/nixpkgs/issues/32881
self: super:
{
  steam = super.steam.override {
    extraPkgs = super: with super; [
      gnome3.gtk
      zlib
      dbus
      freetype
      glib
      atk
      cairo
      gdk_pixbuf
      pango
      fontconfig
      xorg.libxcb
    ];
  };
}
