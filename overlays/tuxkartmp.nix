self: super:

{
  superTuxKartmp = super.superTuxKart.overrideAttrs(old: rec {
    name = "superTuxKart-multiplayer";
    srcs = [
      (super.fetchFromGitHub {
        owner	= "supertuxkart";
        repo	= "stk-code";
        rev	= "bb31d6b2265b86f5128f940584cee5ae3f033eaf";
        sha256	= "0dpc3jrwdc7wv12z3hs0xc5xcdmh9i36164l46fi28bhfj9234c0";
        name	= "stk-code";
      })
      (super.fetchsvn {
        url	= "https://svn.code.sf.net/p/supertuxkart/code/stk-assets";
        rev	= "17940";
        sha256	= "1nhzvqh7x4jdvrck8k5xm7pvc6vyyjrdkqzlr2jnpx08mgjvgl0d";
        name	= "stk-assets";
      })
    ];
  });
}
