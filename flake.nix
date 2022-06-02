{
  description = "dandellion's home-manager profiles";

  inputs  = {
    home-manager-2205.url = "github:nix-community/home-manager/release-22.05";
    nixos-2205.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager-2205.inputs.nixpkgs.follows = "nixos-2205";

    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "unstable";

    dan.url = "gitlab:Dandellion/NUR?host=git.dodsorf.as"; #"git+https://git.dodsorf.as/Dandellion/NUR";
    dan.inputs.nixpkgs.follows = "unstable";
  };

  outputs = {self, home-manager-2205, unstable, nur, dan, ... }:
  let
    nixlib = unstable.lib;

    mkHome =
      { machine
      , hmChannel ? home-manager-2205
      , configuration ? self.nixosModules.home-manager.${machine}
      , system ? "x86_64-linux"
      , username ? "daniel"
      , homeDirectory ? "/home/${username}"
      , stateVersion ? "22.05"
      , extraSpecialArgs ? { inherit (self) overlays; }
      }:
      hmChannel.lib.homeManagerConfiguration {
        inherit configuration system username homeDirectory stateVersion extraSpecialArgs;
      };
  in
  {
    homeConfigurations = nixlib.genAttrs [ "laptop" "desktop" ] (machine: mkHome { inherit machine; })
      // nixlib.genAttrs [ "pvv-terminal" ] (machine: mkHome {inherit machine; username = "danio"; homeDirectory = "/home/pvv/d/danio";});

    nixosModules = {
      home-manager = nixlib.genAttrs [ "laptop" "desktop" "pvv-terminal" ] (machine: import ./machines/${machine}.nix);
    };

    overlays = [
      (final: prev: {
        unstable = import unstable {
          inherit (prev) system config;
        };
        dan = dan.packages.${prev.system};
      })
      nur.overlay
    ];
  };
}