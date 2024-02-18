{ pkgs, config, lib, ... }: {
  system.stateVersion = "24.05";
  environment.systemPackages = with pkgs; [
    vim
    emacs-nox
    tmux
    screen
    usbutils
    pciutils
    jq
    git
    rsync
    wget
    bc
  ];

  users = {
    extraGroups = { gpio = { }; };
    extraUsers.pi = {
      isNormalUser = true;
      initialPassword = "nixos";
      extraGroups = [ "wheel" "networkmanager" "dialout" "gpio" "i2c" ];
    };
  };
  services.getty.autologinUser = "pi";
  security.sudo.wheelNeedsPassword = false;

  networking.wireless = {
    enable = true;
    interfaces = [ "wlan0" ];
    networks = { "Vivaldi" = { psk = "#laprimavera1723#"; }; };
  };
  networking.interfaces.wlan0 = {
    ipv4.addresses = [{
      address = "192.168.2.16";
      prefixLength = 24;
    }];
  };
  networking.hostName = "usb-pi";
  networking.defaultGateway = "192.168.2.1";
  networking.nameservers = [ "1.1.1.1" ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "yes";
  };
}
