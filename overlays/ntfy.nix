self: super:
{
  python = super.python.override {
    packageOverrides = python-self: python-super: {
      ntfy = python-super.ntfy.overrideAttrs (oldAttrs: {
        src = super.fetchgit {
          url = "https://github.com/dali99/ntfy";
          rev = "7b51d148bf1649cb95bf819b57e3b89b12c2e294";
          sha256 = "0rzmc95ybpxbjp36jhssgs2f4c1c32f9a7s4hkwyin67131v9v8k";
        };
        propagatedBuildInputs = with python-self; [ requests ruamel_yaml appdirs mock sleekxmpp emoji psutil dbus-python matrix-client ];
        preBuild = ''
          export HOME="$TMP"
        '';
      });
    };
  };
}
