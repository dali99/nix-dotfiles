{
  description = "dandellion's home-manager profiles";
  
  nixConfig.extra-substituters = ["https://cache.dodsorf.as"];
  nixConfig.exta-trusted-public-keys = "cache.dodsorf.as:FYKGadXTyI2ax8mirBTOjEqS/8PZKAWxiJVOBjESQXc=";

  inputs  = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nur.url = "github:nix-community/NUR";

    dan.url = "git+https://git.dodsorf.as/Dandellion/NUR.git"; #"git+https://git.dodsorf.as/Dandellion/NUR";
    dan.inputs.nixpkgs.follows = "unstable";
    
    # helix.url = "github:helix-editor/helix";
    # helix.inputs.nixpkgs.follows = "unstable";

    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, nixpkgs, home-manager, unstable, nur, dan, nixgl, ... }@inputs:
  let
    nixlib = unstable.lib;

    mkHome =
      { machine
      , configuration ? self.nixosModules.home-manager.${machine}
      , system ? "x86_64-linux"
      , username ? "daniel"
      , homeDirectory ? "/home/${username}"
      , stateVersion ? "22.05"
      , extraSpecialArgs ? { inherit (self) overlays; }
      }:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          configuration
          {
            home = {
              inherit username homeDirectory stateVersion;
            };
          }
        ];
        inherit extraSpecialArgs;
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
        # helix = inputs.helix.packages.${prev.system}.helix;
      })
      nur.overlay
      nixgl.overlay
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
