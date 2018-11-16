self: super:
{
  python = super.python.override {
    packageOverrides = python-self: python-super: {
      ntfy = python-super.ntfy.overrideAttrs (oldAttrs: {
        src = super.fetchgit {
          url = "https://github.com/dali99/ntfy";
          rev = "aa6273bd4c4a4e40a861060c4fc757fe121e7866";
          sha256 = "0zgkd1z4dimlzbs53x3797cq42x0r03nf4r1mjj2mvypnm5nijjp";
        };
        propagatedBuildInputs = with python-self; [ requests ruamel_yaml appdirs mock sleekxmpp emoji psutil dbus-python matrix-client ];
        preBuild = ''
          export HOME="$TMP"
        '';
      });
    };
  };
}
