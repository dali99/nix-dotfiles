self: super:
{
  python = super.python.override {
    packageOverrides = python-self: python-super: {
      ntfy = python-super.ntfy.overrideAttrs (oldAttrs: {
        src = super.fetchgit {
          url = "https://github.com/dschep/ntfy";
          rev = "1f6721cb6e41d3fd0de6ddb7a4f1302551e1c783";
          sha256 = "1n08w6h1narq3jwhd4k1p23hyysn6knaij0r1gpnakx9437h6yk4";
        };
        propagatedBuildInputs = with python-self; [ requests ruamel_yaml appdirs mock sleekxmpp emoji psutil dbus-python matrix-client ];
        preBuild = ''
          export HOME="$TMP"
        '';
      });
    };
  };
}
