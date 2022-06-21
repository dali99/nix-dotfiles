{
  description = "dandellion's home-manager profiles";
  
  nixConfig.extra-substituters = ["https://cache.dodsorf.as"];
  nixConfig.exta-trusted-public-keys = "cache.dodsorf.as:FYKGadXTyI2ax8mirBTOjEqS/8PZKAWxiJVOBjESQXc=";

  inputs  = {
    home-manager-2205.url = "github:nix-community/home-manager/release-22.05";
    nixos-2205.url = "github:nixos/nixpkgs/nixos-22.05";
    home-manager-2205.inputs.nixpkgs.follows = "nixos-2205";

    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "unstable";

    dan.url = "gitlab:Dandellion/NUR?host=git.dodsorf.as"; #"git+https://git.dodsorf.as/Dandellion/NUR";
    dan.inputs.nixpkgs.follows = "unstable";
    
    helix.url = "github:helix-editor/helix";
    helix.inputs.nixpkgs.follows = "unstable";
  };

  outputs = {self, home-manager-2205, unstable, nur, dan, ... }@inputs:
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

      mkHomes = machines: extraArgs: nixlib.genAttrs machines (machine: mkHome ({inherit machine; } // extraArgs));
      
      allMachines = [ "laptop" "desktop" "headless" "pvv-terminal" ];
  in
  {
    
    homeConfigurations = mkHomes [ "laptop" "headless" ] { }
      // mkHomes [ "desktop" ] { username = "dan"; }
      // mkHomes [ "pvv-terminal" ] { username = "danio"; homeDirectory = "/home/pvv/d/danio"; };

    nixosModules = {
      home-manager = nixlib.genAttrs allMachines (machine: import ./machines/${machine}.nix);
    };

    overlays = [
      (final: prev: {
        unstable = import unstable {
          inherit (prev) system config;
        };
        dan = dan.packages.${prev.system};
        helix = inputs.helix.packages.${prev.system}.helix;
      })
      nur.overlay
    ];

    homeActivations = nixlib.genAttrs allMachines (machine: self.homeConfigurations.${machine}.activationPackage);

    apps.x86_64-linux = nixlib.genAttrs allMachines (machine: {
      type = "app";
      program = "${self.homeActivations.${machine}}/activate";
    });
    
    hydraJobs = {
      laptop.x86_64-linux = self.homeActivations.laptop;
      desktop.x86_64-linux = self.homeActivations.desktop;
    };
  };
}
