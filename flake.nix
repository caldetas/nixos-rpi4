{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
  };
  outputs = { self, nixpkgs, nixos-hardware }:
    let
      system = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          nixos-hardware.nixosModules.raspberry-pi-4
          "${nixpkgs}/nixos/modules/profiles/minimal.nix"
          ./configuration.nix
          ./base.nix
        ];
      };
      image = (system.extendModules {
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          # ./sd-image-aarch64.nix
          { disabledModules = [ "profiles/base.nix" ]; }
        ];
      }).config.system.build.sdImage;
    in {
      nixosConfigurations = { pi = system; };
      images.pi = image;

        description = "NixOS configuration with flakes";
        inputs.nixos-hardware.url = "github:NixOS/nixos-hardware/master";

        outputs = { self, nixpkgs, nixos-hardware }: {
          # replace <your-hostname> with your actual hostname
          nixosConfigurations.pi = nixpkgs.lib.nixosSystem {
            # ...
            modules = [
              # ...
              # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
              nixos-hardware.nixosModules.raspberry-pi
            ];
          };
        };
    };
}
