{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-faster.url = "github:nixos/nixpkgs/nixos-unstable-small";
    home-manager.url = "github:nix-community/home-manager";
    antifennel = {
      url = "git+https://git.sr.ht/~technomancy/antifennel";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-faster, home-manager, antifennel, ... }:
    let
      mkNixosConfig = machineSpecificArgs: nixpkgs.lib.nixosSystem {
        inherit (machineSpecificArgs) system;
        modules = [
          ({ config, lib, ... }: {
            options.machineSpecific = {
              name = lib.mkOption {
                type = lib.types.nonEmptyStr;
                default = machineSpecificArgs.name;
              };
              system = lib.mkOption {
                type = lib.types.nonEmptyStr;
                default = machineSpecificArgs.system;
              };
              ethernet = lib.mkOption {
                type = lib.types.bool;
                default = machineSpecificArgs.ethernet;
              };
              server = lib.mkOption {
                type = lib.types.bool;
                default = machineSpecificArgs.server;
              };
            };
            # ===========
            # Since we're creating options in the same module, must
            # prefix any options set in this module with 'config.'
            #
            # nixos uses networking.hostName to choose which configuration to
            # activate. in external (unsynced) file to avoid merge conflicts
            # * should contain a line of the form 'hostname = "<value>"'
            # * TOML because it can't contain newlines, must be exact
            # ===========
            config.networking.hostName = (builtins.fromTOML (builtins.readFile
              ./files/system/exclude/hostname.toml)).hostname;
          })
          # don't need to explicitly specify an attribute set with 'pkgs' here?
          # I guess nothing requires it?
          (_: {
            nixpkgs.overlays = [
              (_: prev: {
                myAntifennel = prev.stdenv.mkDerivation {
                  name = "antifennel";
                  src = antifennel;
                  buildInputs = [ prev.luajit ];
                  installPhase = ''
                    mkdir -p $out/bin
                    cp antifennel $out/bin
                  '';
                  LUA_PATH = "?.lua;;";
                };
              })
              (_: prev: {
                myFennel = prev.luajitPackages.fennel.overrideAttrs (_: {
                  nativeBuildInputs = prev.luajitPackages.fennel.nativeBuildInputs ++ [
                    prev.luajitPackages.readline
                  ];
                });
              })
              (_: prev: { firefox = nixpkgs-faster.legacyPackages.${prev.system}.firefox; })
              # Do we really need to wrap prev.system in ${}?
              #
              # ===========
              # Here's how to add a package
              # * (final: prev: { myNeovim = neovim.defaultPackage.${prev.system}; })
              # Here's how to downgrade a package
              # * (final: prev: { libvirt =
              #     nixpkgs-stable.legacyPackages.${prev.system}.libvirt; })
              # Here's how to override a package
              # * (_: prev: { foot = prev.foot.overrideAttrs (_: { src = foot-src; }); } )
              # Here's how to import a 'classic' overlay (with no flake support?)
              # * (import self.inputs.emacs-overlay)
              # ===========
            ];
          })
          ./configuration.nix
          home-manager.nixosModules.home-manager
          {
            # ===========
            # Use the system nixpkgs, not home-manager's own
            # This causes it to use our overlays
            # ===========
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.hemant = import ./home.nix;
          }
        ];
      };
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixpkgs-fmt;

      nixosConfigurations.casper = mkNixosConfig {
        system = "x86_64-linux";
        ethernet = false;
        server = false;
        name = "casper";
      };

      nixosConfigurations.hambone = mkNixosConfig {
        system = "x86_64-linux";
        ethernet = true;
        server = true;
        name = "hambone";
      };
    };
}
