self: super:
{
  ffmpeggit = super.ffmpeg-full.overrideAttrs (old: rec {
    version = "4.2.2-04pkq2y2";
    src = super.fetchurl {
      url = "http://www.ffmpeg.org/releases/ffmpeg-snapshot-git.tar.bz2";
      sha256 = "14pjy4w7a9g5dn5mssd5lzfl6pz5g8wgqz9fd4cb26dbrfb97i1b";
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
