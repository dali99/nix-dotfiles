{
  description = "dandellion's home-manager profiles";

  inputs  = {
    home-manager-2205.url = "github:nix-community/home-manager/release-22.05";
    nixos-2205.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager-2205.inputs.nixpkgs.follows = "nixos-2205";

    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "unstable";

    dan.url = "git+https://git.dodsorf.as/Dandellion/NUR";
    dan.inputs.nixpkgs.follows = "unstable";
  };

  outputs = {self, home-manager-2205, unstable, nur, dan, ... }:
  let
    pvv-home = "/home/pvv/d/${pvv-username}";
    pvv-username = "danio";
  in
  {
    homeConfigurations.laptop = home-manager-2205.lib.homeManagerConfiguration {
      configuration = import ./machines/laptop.nix;
      system = "x86_64-linux";
      username = "daniel";
      homeDirectory = "/home/daniel";
      stateVersion = "22.05";
      extraSpecialArgs = { inherit (self) overlays; };
    };


    homeConfigurations.pvv-terminal = home-manager-2205.lib.homeManagerConfiguration {
      configuration = import ./machines/pvv-terminal.nix;
      system = "x86_64-linux";
      username = pvv-username;
      homeDirectory = pvv-home;
      stateVersion = "22.05";
      extraSpecialArgs = { inherit (self) overlays; };
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
