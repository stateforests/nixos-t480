{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
  ];

  # ---------------------------------------------------------------------------
  # Boot
  # ---------------------------------------------------------------------------

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ---------------------------------------------------------------------------
  # Networking
  # ---------------------------------------------------------------------------

  networking.hostName = "t480";

  networking.networkmanager = {
    enable = true;

    # Secrets are deliberately kept outside the Nix configuration.
    #
    # Create /etc/nixos/network-secrets.env from network-secrets.env.example
    # and chmod it to 600.
    ensureProfiles = {
      environmentFiles = [ "/etc/nixos/network-secrets.env" ];

      profiles = {
        eduroam = {
          connection = {
            id = "eduroam";
            type = "wifi";
            autoconnect = true;
          };

          wifi = {
            mode = "infrastructure";
            ssid = "eduroam";
          };

          ipv4.method = "auto";
          ipv6.method = "auto";

          wifi-security = {
            key-mgmt = "wpa-eap";
          };

          "802-1x" = {
            eap = "peap";
            identity = "$EDUROAM_IDENTITY";
            password = "$EDUROAM_PASSWORD";
            phase2-auth = "mschapv2";
          };
        };

        pure9522 = {
          connection = {
            id = "pure9522";
            type = "wifi";
            autoconnect = true;
          };

          wifi = {
            mode = "infrastructure";
            ssid = "pure9522";
          };

          ipv4.method = "auto";
          ipv6.method = "auto";

          wifi-security = {
            key-mgmt = "wpa-psk";
            psk = "$PURE9522_PASSWORD";
          };
        };
      };
    };
  };

  networking.firewall.enable = true;

  # ---------------------------------------------------------------------------
  # Locale / keyboard / time
  # ---------------------------------------------------------------------------

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  services.xserver.xkb.layout = "gb";

  nixpkgs.config.allowUnfree = true;

  # ---------------------------------------------------------------------------
  # X11 + bspwm
  # ---------------------------------------------------------------------------

  services.xserver = {
    enable = true;

    windowManager.bspwm.enable = true;

    displayManager.startx.enable = true;
  };

  # ---------------------------------------------------------------------------
  # Terminal greeter
  # ---------------------------------------------------------------------------

  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd startx";
        user = "greeter";
      };
    };
  };

  # ---------------------------------------------------------------------------
  # Audio
  # ---------------------------------------------------------------------------

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  security.rtkit.enable = true;

  # ---------------------------------------------------------------------------
  # Laptop power / thermals
  # ---------------------------------------------------------------------------

  services.tlp.enable = true;
  services.thermald.enable = true;

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };

  services.fstrim.enable = true;

  zramSwap.enable = true;

  # ---------------------------------------------------------------------------
  # Hardware
  # ---------------------------------------------------------------------------

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.cpu.intel.updateMicrocode = true;

  hardware.bluetooth.enable = true;

  # Firmware updates; no resident GUI.
  services.fwupd.enable = true;

  # ---------------------------------------------------------------------------
  # User
  # ---------------------------------------------------------------------------

  users.users.tom = {
    isNormalUser = true;
    description = "Tom";

    extraGroups = [
      "wheel"
      "networkmanager"
      "audio"
      "video"
    ];
  };

  security.sudo.wheelNeedsPassword = true;

  # ---------------------------------------------------------------------------
  # Nix
  # ---------------------------------------------------------------------------

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.auto-optimise-store = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # ---------------------------------------------------------------------------
  # XDG directories
  # ---------------------------------------------------------------------------

  systemd.tmpfiles.rules = [
    "d /home/tom/files 0755 tom users -"
    "d /home/tom/files/downloads 0755 tom users -"
    "d /home/tom/files/documents 0755 tom users -"
    "d /home/tom/files/media 0755 tom users -"
    "d /home/tom/files/media/music 0755 tom users -"
    "d /home/tom/files/media/photos 0755 tom users -"
    "d /home/tom/files/media/videos 0755 tom users -"
    "d /home/tom/files/projects 0755 tom users -"
    "d /home/tom/files/archives 0755 tom users -"
    "d /home/tom/files/unsorted 0755 tom users -"

    "d /home/tom/.config 0755 tom users -"
    "d /home/tom/.config/bspwm 0755 tom users -"
    "d /home/tom/.config/sxhkd 0755 tom users -"
    "d /home/tom/.config/polybar 0755 tom users -"
    "d /home/tom/.config/rofi 0755 tom users -"
    "d /home/tom/.config/dunst 0755 tom users -"

    "L+ /home/tom/.config/bspwm/bspwmrc - - - - /etc/xdg/bspwm/bspwmrc"
    "L+ /home/tom/.config/sxhkd/sxhkdrc - - - - /etc/xdg/sxhkd/sxhkdrc"
    "L+ /home/tom/.config/polybar/config.ini - - - - /etc/xdg/polybar/config.ini"
    "L+ /home/tom/.config/rofi/config.rasi - - - - /etc/xdg/rofi/config.rasi"
    "L+ /home/tom/.config/dunst/dunstrc - - - - /etc/xdg/dunst/dunstrc"
  ];

  environment.etc = {
    "xdg/bspwm/bspwmrc".source = ../../config/bspwm/bspwmrc;
    "xdg/sxhkd/sxhkdrc".source = ../../config/sxhkd/sxhkdrc;
    "xdg/polybar/config.ini".source = ../../config/polybar/config.ini;
    "xdg/rofi/config.rasi".source = ../../config/rofi/config.rasi;
    "xdg/dunst/dunstrc".source = ../../config/dunst/dunstrc;
    "Xresources".source = ../../config/Xresources;

    "xdg/user-dirs.defaults".text = ''
      XDG_DOWNLOAD_DIR="$HOME/files/downloads"
      XDG_DOCUMENTS_DIR="$HOME/files/documents"
      XDG_MUSIC_DIR="$HOME/files/media/music"
      XDG_PICTURES_DIR="$HOME/files/media/photos"
      XDG_VIDEOS_DIR="$HOME/files/media/videos"
      XDG_DESKTOP_DIR="$HOME/files/unsorted"
      XDG_PUBLICSHARE_DIR="$HOME/files/unsorted"
      XDG_TEMPLATES_DIR="$HOME/files/unsorted"
    '';

    "X11/xinit/xinitrc".source = ../../config/xinitrc;
  };

  # ---------------------------------------------------------------------------
  # Session environment
  # ---------------------------------------------------------------------------

  environment.sessionVariables = {
    EDITOR = "nano";
    VISUAL = "subl";
    BROWSER = "firefox";
    TERMINAL = "xterm";
  };

  # ---------------------------------------------------------------------------
  # NixOS release
  # ---------------------------------------------------------------------------

  system.stateVersion = "26.05";
}
