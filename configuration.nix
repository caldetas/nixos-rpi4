let
  sshkeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDG93Lrx68lLdsuDL81JY95RhBCMOZEBQAWaU4z8VLk+3uaNgMnuY4l/1DwFBTo5PStEod/gk4PWyYX/y4PgoXSDxiGNtIe9ZipXnrNyWFDblihchuLtEDV37GC+YOgZBysLWLmwZ4nL8wxUUPNhOnjSF9nPapmnvpV1eYwb+1DfsWdJ9nJ5tE/B3u6YDAm54nOU75ctk60gB7HWIq7slMWGWTpXuN0M1YhJSUb6UjeFAcQDlHCvIN2F0SEZgbax80xBlTcSKkvCJlOe1RZ0wYTItYW5fbLweeHuqJPU7s2U8F9ytqzhHBxRfQCh64sWVylOQ7PJ+RUGYgK6e4EwzSd3X+PQV7nZMYM6WUk890xnHbER+pNmtorPaBoX4EJvfwYS4v7boZ74xi/DuflT0h3J4GXmoaumD0mTVFgnyc6gkoHEi5B+bm5MRldiGRCyMmOOxq/zvEjcmB/Obj1BR0C+c11uFC4dEhIjBHWej+Kdju6ZqH0d9zksr2YgKMs4Lc= hhartmann@pve"
  ];
in { pkgs, config, lib, ... }: {
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

    libraspberrypi
    libgpiod
    gpio-utils
    i2c-tools

    python39
    python39Packages.pip
    (python39.withPackages
      (ps: with ps; [ adafruit-pureio adafruit-io pyserial ]))
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
    networks = { "Vivaldi" = { psk = "#laprimavera1723#"; }; };
  };
  networking.interfaces.wlan0 = {
    ipv4.addresses = [{
      address = "192.168.2.15";
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
