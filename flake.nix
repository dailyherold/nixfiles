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
    ...
  } @ inputs: let
    inherit (self) outputs;
    lib = nixpkgs.lib // home-manager.lib;
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
        modules = [./hosts/nixzen disko.nixosModules.disko];
        specialArgs = {inherit inputs outputs;};
      };
    };

    # nix-darwin configuration entrypoint
    # Available through 'darwin-rebuild switch --flake .#your-hostname'
    darwinConfigurations = {
      # Work MacBook Air
      "Mac-K74WPYK2" = nix-darwin.lib.darwinSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
          ./hosts/Mac-K74WPYK2
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {inherit inputs outputs;};
            home-manager.users.e133949 = {
              imports = [
                ./home-manager/Mac-K74WPYK2.nix
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
