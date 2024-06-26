let
  sshkeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILECy6PK+pg6QaEoKQ4sr32COh14nnEE5BdzmqOK13Ca rspi4@example.com"
  ];
in { pkgs, config, lib, ... }: {
  system.stateVersion = "24.05";
   nixpkgs.config.allowUnfree = true; # Allow Proprietary Software.
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
#    steam

    libraspberrypi
    libgpiod
    gpio-utils
    i2c-tools
#    plasma-nm

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
#  networking.wireless = {
#    enable = true;
#    networks."robot".psk = "frijolito";
#    extraConfig = "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=wheel";
#  };
    services.xserver.enable = true;
    services.xserver.displayManager = {
        gdm.enable = true;
        autoLogin = {
                enable = true;
                user = "pi";
            };
    };
    services.xserver.desktopManager.gnome.enable = true;
#    services.xserver.displayManager.sddm.enable = true;
#    services.xserver.desktopManager.plasma5.bigscreen.enable = true;
#    services.xserver.desktopManager.plasma5.enable = true;
#  networking.interfaces.wlan0 = {
#    ipv4.addresses = [{
#      address = "192.168.178.102";
#      prefixLength = 24;
#    }];
#  };
  networking.hostName = "nixos";

#  networking.defaultGateway = "192.168.178.1";
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "yes";
  };
    time.timeZone = "Europe/Zurich"; # Time zone and Internationalisation
    i18n = {
      defaultLocale = "en_US.UTF-8";
      extraLocaleSettings = {
        LC_TIME = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
      };
    };

    console = {
      font = "Lat2-Terminus16";
      keyMap = "sg";
    };
    services.flatpak.enable = true;
      xdg.portal.enable = true;
      xdg.portal.config =
        {
          common = {
            default = [
              "gtk"
            ];
          };
          pantheon = {
            default = [
              "pantheon"
              "gtk"
            ];
            "org.freedesktop.impl.portal.Secret" = [
              "gnome-keyring"
            ];
          };
          x-cinnamon = {
            default = [
              "xapp"
              "gtk"
            ];
          };
        };
#    flatpak.enable = true;
#    flatpak = {
#    # Flatpak Packages (see module options)
#    extraPackages = [
#      "com.github.tchx84.Flatseal"
#      "io.github.mimbrero.WhatsAppDesktop"
#      "org.signal.Signal"
#
#    ];
#    };
  environment.etc."tmux.conf".source = ./tmux.conf;

}
