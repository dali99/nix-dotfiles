self: super:
{
  mylibaom = super.libaom.overrideAttrs (old: rec {
    version = "1.0.0-fdca7c6440";
    src = super.fetchgit {
      url = "https://aomedia.googlesource.com/aom";
      rev = "fdca7c64406efeb3a5f9012801bf122b06d2045a";
      sha256 = "00f7cvmcj094sdw0i35633yn1ng9w38wl761k1fx6ns8w0byirv1";
    };


    cmakeFlags = [
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
    ];
  });

}
