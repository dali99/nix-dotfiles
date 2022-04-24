let
  unstable = import <unstable> { }; 
  stable = import <nixpkgs> {};
  nur = import <nur> { pkgs = unstable; };
in
{
  allowUnfree = true;
 
  packageOverrides = pkgs: {
    unstable = unstable;
    nur = nur;
    dan = import <dan> {
      pkgs = unstable;
    };
    danstable = <dan> {
      pkgs = stable;
    };
  };
}
