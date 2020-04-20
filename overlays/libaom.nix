self: super:
{
  mylibaom = super.libaom.overrideAttrs (old: rec {
    version = "1.0.0-g33e9b7fb1";
    src = super.fetchgit {
      url = "https://aomedia.googlesource.com/aom";
      rev = "33e9b7fb1c5f14657142b8a54e5166f5240821d7";
      sha256 = "10viwhjh0qm600ych8652q2a04351qy6fj26qzm4nszncflj4g7w";
    };


    cmakeFlags = [
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
    ];
  });

}
