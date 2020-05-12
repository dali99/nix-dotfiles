self: super:
{
  ffmpeggit = super.ffmpeg-full.overrideAttrs (old: rec {
    version = "4.2.2";
    src = super.fetchurl {
      url = "http://www.ffmpeg.org/releases/ffmpeg-snapshot-git.tar.bz2";
      sha256 = "1lj7spgmv2kqiz25dpy2gzbciqdsm7j3q1s1j4csnal5jyq6a28m";
    };
    configureFlags = [
      "--enable-gpl"
      "--enable-version3"
      "--enable-static"
      "--disable-debug"
      "--disable-ffplay"
      "--disable-indev=sndio"
      "--disable-outdev=sndio"
      "--cc=gcc"
      "--enable-fontconfig"
      "--enable-frei0r"
      "--enable-gnutls"
      "--enable-gmp"
      "--enable-libgme"
      "--enable-gray"
      "--enable-libaom"
      "--enable-libfribidi"
      "--enable-libass"
      "--enable-libvmaf"
      "--enable-libfreetype"
      "--enable-libmp3lame"
      "--enable-libopencore-amrnb"
      "--enable-libopencore-amrwb"
      "--enable-libopenjpeg"
      "--enable-libsoxr"
      "--enable-libspeex"
      "--enable-libvorbis"
      "--enable-libopus"
      "--enable-libtheora"
      "--enable-libvidstab"
      "--enable-libvo-amrwbenc"
      "--enable-libvpx"
      "--enable-libwebp"
      "--enable-libx264"
      "--enable-libx265"
      "--enable-libdav1d"
      "--enable-libxvid"
    ];
    patches = [];
  });
  myffmpeg = self.ffmpeggit.override (OldAttr: {
    libaom = self.mylibaom;
  });

}
