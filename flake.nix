{
  description = "dandellion's home-manager profiles";

  # nixConfig.extra-substituters = ["https://cache.dodsorf.as"];
  # nixConfig.exta-trusted-public-keys = "cache.dodsorf.as:FYKGadXTyI2ax8mirBTOjEqS/8PZKAWxiJVOBjESQXc=";

  inputs  = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";

    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nur.url = "github:nix-community/NUR";

    dan.url = "git+https://git.dodsorf.as/Dandellion/NUR.git?ref=master"; #"git+https://git.dodsorf.as/Dandellion/NUR";
    dan.inputs.nixpkgs.follows = "unstable";

    wack-server-conf.url = "github:WackAttackCTF/wack-server-conf";
    wack-server-conf.inputs.nixpkgs.follows = "nixpkgs";

    wack-ctf.url = "github:WackAttackCTF/wack-ctf-flake";
    wack-ctf.inputs.nixpkgs.follows = "nixpkgs";

    greg-clients.url = "git+https://git.pvv.ntnu.no/grzegorz/grzegorz-clients";
    greg-clients.inputs.nixpkgs.follows = "unstable";

    # helix.url = "github:helix-editor/helix";
    # helix.inputs.nixpkgs.follows = "unstable";

    nixgl.url = "github:guibou/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {self, nixpkgs, home-manager, unstable, nixos-hardware, nur, dan, nixgl, ... }@inputs:
  let
    nixlib = unstable.lib;

    defaultOverlays = [
      (final: prev: {
        unstable = import unstable {
          inherit (prev) system config;
        };
        dan = dan.packages.${prev.system};
        grzegorz-clients = inputs.greg-clients.packages.${prev.system}.grzegorz-clients;
        gregctl = inputs.greg-clients.packages.${prev.system}.grzegorzctl;
        # helix = inputs.helix.packages.${prev.system}.helix;
        wack = inputs.wack-ctf.packages.${prev.system}.wack;
      })
      nur.overlays.default
      nixgl.overlays.default
    ];

    mkHome =
      { machine
      , configuration ? self.nixosModules.home-manager.${machine}
      , system ? "x86_64-linux"
      , username ? "daniel"
      , homeDirectory ? "/home/${username}"
      , stateVersion ? "22.05"
      , extraSpecialArgs ? { overlays = defaultOverlays; }
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

      allMachines = [ "laptop" "desktop" "headless" "pvv-terminal" "ikari" ];
  in
  {

    homeConfigurations = mkHomes [ "laptop" "headless" "ikari" ] { }
      // mkHomes [ "desktop" ] { username = "dan"; }
      // mkHomes [ "pvv-terminal" ] { username = "danio"; homeDirectory = "/home/pvv/d/danio"; };

    nixosConfigurations = {
      ayanami = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/ayanami/configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-l480
        ];
      };

      soryu-old = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/asuka/soryu-old/configuration.nix
        ];
      };
      soryu = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = false;
            home-manager.useUserPackages = true;
            home-manager.users.daniel = import ./home/machines/soryu.nix;
            home-manager.extraSpecialArgs = {
              overlays = defaultOverlays;
            };
          }

          ./hosts/asuka/soryu/configuration.nix
        ];
      };
      # langley = nixpkgs.lib.nixosSystem {
      #   system = "x86_64-linux";
      #   specialArgs = {
      #     inherit inputs;
      #   };
      #   modules = [
      #     ./hosts/asuka/langley/configuration.nix
      #   ];
      # };

      ikari = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hosts/ikari/configuration.nix
        ];
      };
    };

    nixosModules = {
      home-manager = nixlib.genAttrs allMachines (machine: import ./home/machines/${machine}.nix);
    };

    homeActivations = nixlib.genAttrs allMachines (machine: self.homeConfigurations.${machine}.activationPackage);

    apps.x86_64-linux = nixlib.genAttrs allMachines (machine: {
      type = "app";
      program = "${self.homeActivations.${machine}}/activate";
    });

    inherit defaultOverlays;

    # hydraJobs = {
    #   laptop.x86_64-linux = self.homeActivations.laptop;
    #   desktop.x86_64-linux = self.homeActivations.desktop;
    # };
  };
}
