{
  description = "NixOS and Home-manager flake";

  inputs = {
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-24.05";
    };
    nixpkgs-unstable = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-unstable";
    };
    home-manager = {
      type = "github";
      owner = "nix-community";
      repo = "home-manager";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    hyprkeys = {
      type = "github";
      owner = "hyprland-community";
      repo = "hyprkeys";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs";
        };
      };
    };
    nur = {
      type = "github";
      owner = "nix-community";
      repo = "NUR";
    };
    gitu = {
      type = "github";
      owner = "altsem";
      repo = "gitu";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    nix-gl = {
      type = "github";
      owner = "nix-community";
      repo = "nixGL";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim = {
      type = "github";
      owner = "nix-community";
      repo = "neovim-nightly-overlay";
      inputs = {
        nixpkgs = {
          follows = "nixpkgs-unstable";
        };
      };
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nix-gl,
    ...
  } @ inputs: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop
        ];
        specialArgs = {
          inherit inputs;
        };
      };
    };
    homeConfigurations = {
      michaell = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [nix-gl.overlay];
        };
        modules = [./home/laptop.nix];

        extraSpecialArgs = {
          inherit inputs;
        };
      };
    };
  };
}
