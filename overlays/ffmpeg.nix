self: super:
{
  ffmpeggit = super.ffmpeg-full.overrideAttrs (old: rec {
    version = "4.2.2-0vhi3x2irg";
    src = super.fetchurl {
      url = "http://www.ffmpeg.org/releases/ffmpeg-snapshot-git.tar.bz2";
      sha256 = "0vhi3x2irgxi9v04m09pawi0dq7gkvq909pk7psk1cypbbv1nlf7";
    };
    configureFlags = [
      "--enable-gpl"
      "--enable-version3"
      "--disable-debug"
      "--enable-static"
      "--disable-ffplay"
      "--disable-indev=sndio"
      "--disable-outdev=sndio"
      "--cc=gcc"
      "--enable-fontconfig"
      "--enable-gnutls"
      "--enable-gmp"
      "--enable-libgme"
      "--enable-gray"
      "--enable-libaom"
      "--enable-libfribidi"
      "--enable-libass"
      "--enable-libfreetype"
      "--enable-libopencore-amrnb"
      "--enable-libopencore-amrwb"
      "--enable-libsoxr"
      "--enable-libopus"
      "--enable-libtheora"
      "--enable-libvo-amrwbenc"
      "--enable-libwebp"
      "--enable-libx264"
      "--enable-libdav1d"
    ];
    patches = [];
  });
  myffmpeg = self.ffmpeggit.override (OldAttr: {
    libaom = self.mylibaom;
  });

}
