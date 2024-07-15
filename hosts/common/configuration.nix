{ config
, pkgs
, inputs
, ...
}: {
  system.stateVersion = "23.11";

  # Bootloader.
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;
        font = "${
          pkgs.nerdfonts.override{fonts=["FiraCode"];}
        }/share/fonts/truetype/NerdFonts/FiraCodeNerdFont-Regular.ttf";
        fontSize = 36;
        # theme = "${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze";
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";
  # FIX dualboot (only on windows) breaks time
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver = {
    enable = true;

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };

    displayManager = {
      sddm.enable = true;
      defaultSession = "none+awesome";
    };

    windowManager.awesome = {
      enable = true;
      luaModules = with pkgs.luaPackages; [
        luarocks # is the package manager for Lua modules
        luadbi-mysql # Database abstraction layer
      ];
    };

    desktopManager = {
      plasma5 = {
        enable = true;
        notoPackage = pkgs.noto-fonts-monochrome-emoji;
      };
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.polkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager
    # (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pango = {
    isNormalUser = true;
    description = "pango";
    extraGroups = [ "networkmanager" "wheel" "docker" "podman" ];
    shell = pkgs.fish;
    useDefaultShell = true;
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    useGlobalPkgs = true;
    users = {
      "pango" = import ../${config.networking.hostName}/home.nix;
    };
  };

  virtualisation = {
    docker.enable = true;
    podman.enable = true;
    spiceUSBRedirection.enable = true;
    containers.cdi.dynamic.nvidia.enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.sessionVariables = {
    FLAKE = "/home/pango/system";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    vim
    git
  ];

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
    atk
    cairo
    gdk-pixbuf
    glib
    glibc
    gobject-introspection
    gtk3
    libgudev
    linuxHeaders
    pango
  ] ++ [
    linuxKernel.kernels.linux_6_9_hardened.dev
  ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  environment.shells = with pkgs; [ fish ];

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = true;
    };
  };
}
