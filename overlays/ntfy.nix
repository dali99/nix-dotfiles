self: super:
{
  ntfy = super.ntfy.overrideAttrs (old: rec {
    src = super.fetchFromGitHub {
      owner = "dschep";
      repo = "ntfy";
      rev = "d7a359bd6e4902e0067c62058179d8c678361154";
      sha256 = "1n08w6h1narq3jwhd4k1p23hyysn6knaij0r1gpnakx9437h6yk4";
    };
  });
}
