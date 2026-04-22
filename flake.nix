{
  description = "Dailyherold Nix Config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Hardware flakes
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # Disks
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # VSCode extensions
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-vscode-extensions.inputs.nixpkgs.follows = "nixpkgs";

    # Catppuccin theme
    catppuccin.url = "github:catppuccin/nix";

    # nix-darwin (macOS system management)
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Bubblewrap-jailed agent wrappers (Linux only)
    jailed-agents.url = "github:andersonjoseph/jailed-agents";

    # Google Workspace CLI (gws)
    googleworkspace-cli.url = "github:googleworkspace/cli";
    googleworkspace-cli.inputs.nixpkgs.follows = "nixpkgs";

    # Secrets management
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Private secrets (soft + hard)
    nix-secrets = {
      url = "git+ssh://git@github.com/dailyherold/nix-secrets?shallow=1";
      flake = true;
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    disko,
    nix-vscode-extensions,
    catppuccin,
    nix-darwin,
    googleworkspace-cli,
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;

    # Temporary: pin himalaya to 1.2.0 until nixpkgs PR #488853 merges.
    # Fixes SASL PLAIN auth hang with Proton Bridge (imap-codec bug).
    himalayaOverlay = final: prev: {
      himalaya = prev.himalaya.overrideAttrs (old: {
        version = "1.2.0";
        src = prev.fetchFromGitHub {
          owner = "pimalaya";
          repo = "himalaya";
          rev = "v1.2.0";
          hash = "sha256-BBzfDeNu7s010ARCYuydCyR7QWrbeI3/B4CxA6d4olw=";
        };
        cargoDeps = prev.rustPlatform.fetchCargoVendor {
          pname = "himalaya";
          version = "1.2.0";
          src = prev.fetchFromGitHub {
            owner = "pimalaya";
            repo = "himalaya";
            rev = "v1.2.0";
            hash = "sha256-BBzfDeNu7s010ARCYuydCyR7QWrbeI3/B4CxA6d4olw=";
          };
          hash = "sha256-IkvRiU9NuD6n7aCF8J235u2LjjmLftnF1n874IWVcN0=";
        };
      });
    };
    systems = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    forEachSystem = f: lib.genAttrs systems (system: f pkgsFor.${system});
    pkgsFor = lib.genAttrs systems (
      system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [himalayaOverlay];
        }
    );
  in {
    inherit lib;
    homeManagerModules = import ./modules/home-manager;
    devShells = forEachSystem (pkgs: import ./shell.nix {inherit pkgs;});
    formatter = forEachSystem (pkgs: pkgs.alejandra);

    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      # Main desktop
      nixzen = nixpkgs.lib.nixosSystem {
        modules = [./hosts/nixzen disko.nixosModules.disko {nixpkgs.overlays = [himalayaOverlay];}];
        specialArgs = {inherit inputs outputs;};
      };
    };

    # nix-darwin configuration entrypoint
    # Available through 'darwin-rebuild switch --flake .#your-hostname'
    darwinConfigurations = {
      # Work MacBook Air
      "jp-sembi-mbp" = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/jp-sembi-mbp
          home-manager.darwinModules.home-manager
          {nixpkgs.overlays = [himalayaOverlay];}
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {inherit inputs outputs;};
            home-manager.users.${inputs.nix-secrets.personal.sembiId} = {
              imports = [
                ./home-manager/jp-sembi-mbp.nix
                catppuccin.homeModules.catppuccin
              ];
            };
          }
        ];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      # Main desktop
      "dailyherold@nixzen" = lib.homeManagerConfiguration {
        pkgs = pkgsFor.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [
          ./home-manager/nixzen.nix
          catppuccin.homeModules.catppuccin
        ];
      };
    };
  };
}
