let
  sshkeys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDG93Lrx68lLdsuDL81JY95RhBCMOZEBQAWaU4z8VLk+3uaNgMnuY4l/1DwFBTo5PStEod/gk4PWyYX/y4PgoXSDxiGNtIe9ZipXnrNyWFDblihchuLtEDV37GC+YOgZBysLWLmwZ4nL8wxUUPNhOnjSF9nPapmnvpV1eYwb+1DfsWdJ9nJ5tE/B3u6YDAm54nOU75ctk60gB7HWIq7slMWGWTpXuN0M1YhJSUb6UjeFAcQDlHCvIN2F0SEZgbax80xBlTcSKkvCJlOe1RZ0wYTItYW5fbLweeHuqJPU7s2U8F9ytqzhHBxRfQCh64sWVylOQ7PJ+RUGYgK6e4EwzSd3X+PQV7nZMYM6WUk890xnHbER+pNmtorPaBoX4EJvfwYS4v7boZ74xi/DuflT0h3J4GXmoaumD0mTVFgnyc6gkoHEi5B+bm5MRldiGRCyMmOOxq/zvEjcmB/Obj1BR0C+c11uFC4dEhIjBHWej+Kdju6ZqH0d9zksr2YgKMs4Lc= hhartmann@pve"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQD5ohtReUl0kFM1Te5TCUVHbcA4CVke47or7SPUWf1cXGq4IBUe7XjLW+2ThFkj0oEzDlKBhRh8kpCmBu7RBukSCRK/1CRZuen+p5ivHYJm+pnZtfiT949eQGIiaI6wGLz+SgM+dmX7/zNebMoBJFZA3Z6bvk0FdMXxVDzWI60dMVhr2gzdpQMETttndbduZ6W8MA8M5aT0aeidn2UXZesedJ0mgt1pxsjRwyw9YcxIfnq3gMH4Fs0HMe5lAEOmt3uyPfdCePRvsIjTleTLMvkBrth0Wh26gWJ2Rk676gFnt1lppvdmNew7FCjNObWdmL2KAMzBXaAL99ihbh8dZe3fqWVj0fNkEwhtfGSJ3NlNNDsHt4hqCE38+wF8JMnN1v1rdJN6SHJUc+F9Uh596KgvqetaiBtcaloTpYq0OV8nwL3o2PCUonOYhlbXmpX++66TgHqqY+dbL3IQxnC7R/jkZ+1ZPjcg8xA3vp8u8fgcRjOfh6sfoKKKROuArlDLteE= hehartmann@ZALANDO-62244"
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

  environment.etc."tmux.conf".source = ./tmux.conf

}
