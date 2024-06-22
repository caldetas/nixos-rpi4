#
#  Gnome Configuration
#  Enable with "gnome.enable = true;"
#


{
    programs = {
      zsh.enable = true;
#      kdeconnect = {
#        # GSConnect
#        enable = true;
#        package = pkgs.gnomeExtensions.gsconnect;
#      };
    };

    services = {
      xserver = {
        enable = true;

        xkb = {
          layout = "ch";
        };

        displayManager.gdm.enable = true; # Display Manager
        desktopManager.gnome.enable = true; # Desktop Environment

      };
      libinput.enable = true;

      #XRDP settings for remmina
#      xrdp.enable = true;
#      #        xrdp.defaultWindowManager =  "gnome-remote-desktop";
#      xrdp.defaultWindowManager = "/run/current-system/sw/bin/gnome-session";
#      xrdp.openFirewall = true;
#      gnome.gnome-remote-desktop.enable = true;

      udev.packages = with pkgs; [
        gnome.gnome-settings-daemon
      ];
    };


    environment = {
      systemPackages = with pkgs.gnome; [
        # System-Wide Packages
        adwaita-icon-theme
        dconf-editorq
        gnome-themes-extra
        gnome-tweaks
      ];
      gnome.excludePackages = (with pkgs; [
        # Ignored Packages
        gnome-tour
      ]) ++ (with pkgs.gnome; [
        atomix
        epiphany
        geary
        gnome-characters
        gnome-contacts
        gnome-initial-setup
        hitori
        iagno
        tali
        yelp
      ]);
    };
}
