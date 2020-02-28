let unstable = import <nixos-unstable> { }; in
{
  allowUnfree = true;
 
  packageOverrides = pkgs: {
    unstable = unstable;
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      pkgs = unstable;
    };
    dan = import (builtins.fetchTarball "https://git.dodsorf.as/Dandellion/NUR/-/archive/master/NUR-master.tar.gz") {
      pkgs = unstable;
    };
  };
}
