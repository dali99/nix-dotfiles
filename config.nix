{
  allowUnfree = true;
  oraclejdk.accept_license = true;

  packageOverrides = pkgs: {
    unstable = import <nixos-unstable> { };
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
    dan = import (builtins.fetchTarball "https://git.dodsorf.as/Dandellion/NUR/-/archive/master/NUR-master.tar.gz") {
      inherit pkgs;
    };
  };
}
