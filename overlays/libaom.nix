self: super:
{
  mylibaom = super.libaom.overrideAttrs (old: rec {
    version = "1.0.0-a5e3f02b186";
    src = super.fetchgit {
      url = "https://aomedia.googlesource.com/aom";
      rev = "a5e3f02b18668957bbd054a1058cb190f298ca6f";
      sha256 = "1i7lk91rdwviqnmxc6k2ihjqx5glf6siirnlhyi50vbqwgpjiyv4";
    };


    cmakeFlags = [
      "-DCMAKE_INSTALL_LIBDIR=lib"
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_INCLUDEDIR=include"
    ];
  });

}
