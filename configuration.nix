let
  sshkeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILECy6PK+pg6QaEoKQ4sr32COh14nnEE5BdzmqOK13Ca rspi4@example.com"
  ];
in { pkgs, config, lib, ... }: {
  system.stateVersion = "24.05";
  environment.systemPackages = with pkgs; [
    vim
    nano
    htop
    emacs-nox
    tmux
    screen
    usbutils
    pciutils
    jq
    git
    rsync

    libraspberrypi
    libgpiod
    gpio-utils
    i2c-tools

  ];

  users = {
    extraGroups = { gpio = { }; };
    extraUsers.pi = {
      isNormalUser = true;
      initialPassword = "nixos";
      openssh.authorizedKeys.keys = sshkeys;
      extraGroups = [ "wheel" "networkmanager" "dialout" "gpio" "i2c" ];
    };
    extraUsers.root = {
      initialPassword = "nixos";
      openssh.authorizedKeys.keys = sshkeys;
    };
  };
  networking.wireless = {
    enable = true;
    interfaces = [ "wlan0" ];
    networks = { "robot" = { psk = "frijolito"; }; };
  };
  networking.interfaces.wlan0 = {
    ipv4.addresses = [{
      address = "192.168.178.102";
      prefixLength = 24;
    }];
  };
  networking.hostName = "usb-pi";
#  networking.defaultGateway = "192.168.178.1";
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "yes";
  };

  environment.etc."tmux.conf".source = ./tmux.conf;

}
