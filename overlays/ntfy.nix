self: super:
{
  python = super.python.override {
    packageOverrides = python-self: python-super: {
      ntfy = python-super.ntfy.overrideAttrs (oldAttrs: {
        src = super.fetchgit {
          url = "https://github.com/dschep/ntfy";
          rev = "c16526bbaf5149db6bc4ef12f2f2c06c114cce45";
          sha256 = "1myj6krccnnxhs6lgl42199ygcaxmmrqp1lqrvn8i1ypm3qryc9b";
        };
        propagatedBuildInputs = with python-self; [ requests ruamel_yaml appdirs mock sleekxmpp emoji psutil dbus-python matrix-client ];
        preBuild = ''
          export HOME="$TMP"
        '';
      });
    };
  };
}
