self: super:
{
  mylibaom = super.libaom.overrideAttrs (old: rec {
    version = "1.0.0-g33e9b7fb1";
    src = super.fetchgit {
      url = "https://aomedia.googlesource.com/aom";
      rev = "e6a12489069fdf7188963950cdec8ef7ef333f1d";
      sha256 = "1ncvn5l8zczkjxfmld2ppcwqkc80pm38y1qaf1yil1llfx85xvhh";
    };


    cmakeFlags = [
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
    ];
  });

}
