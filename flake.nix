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
      image = (system.pi.extendModules {
        modules = [
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          { disabledModules = [ "profiles/base.nix" ]; }
        ];
      }).config.system.build.sdImage;
    in {
      nixosConfigurations = { pi = system; };
      images.pi = image;
      packages.x86_64-linux.pi-image = image;
      packages.aarch64-linux.pi-image = image;
    };
}
