{ pkgs, config, lib, ... }: {
  # This causes an overlay which causes a lot of rebuilding
  environment.noXlibs = lib.mkForce false;

  # "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix" creates a
  # disk with this label on first boot. Therefore, we need to keep it. It is the
  # only information from the installer image that we need to keep persistent
  fileSystems."/" = {
    device = "/dev/disk/by-label/NIXOS_SD";
    fsType = "ext4";
  };

  hardware.i2c.enable = true;

  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_latest;
    kernelParams = [ "console=ttyAMA0,115200n8" "console=ttyS0,115200n8" ];
    loader = {
      generic-extlinux-compatible.enable = lib.mkDefault true;
      grub.enable = lib.mkDefault false;
    };
    kernelModules = [ "i2c-dev" ];
    initrd.availableKernelModules = pkgs.lib.mkForce [ "mmc_block" ];
  };
  nix.settings = {
    experimental-features = lib.mkDefault "nix-command flakes";
    trusted-users = [ "root" "@wheel" "pi" ];
    substituters =
      [ "https://cache.nixos.org" ];
  };
}
