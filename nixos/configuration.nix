{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  unstable = import <nixos-unstable> {config = {allowUnfree = true;};};
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    inputs.home-manager.nixosModules.home-manager
  ];

  # nix = {
  #   package = pkgs.nixFlakes;
  #   extraOptions =
  #     lib.optionalString (config.nix.package == pkgs.nixFlakes)
  #     "experimental-features = nix-command flakes";
  # };
  nix.settings.experimental-features = ["nix-command" "flakes"];

  home-manager = {
    extraSpecialArgs = {inherit inputs;};
    users.pango = import ../home-manager/home.nix;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pangolinux"; # Define your hostname.
  # networking.wireless.enable = true;	# Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

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
    # Enable the X11 windowing system.
    enable = true;

    # Enable the KDE Plasma Desktop Environment.
    displayManager.sddm.enable = true;
    desktopManager.plasma5.enable = true;

    displayManager = {
      # Enable automatic login for the user.
      autoLogin.enable = true;
      autoLogin.user = "pango";
    };
  };

  security.pam.services.kwallet = {
    name = "kwallet";
    enableKwallet = true;
  };

  # Configure keymap in X11
  # services.xserver = {
  #   layout = "en";
  #   xkbVariant = "";
  # };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # fix unity login page not opening
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
  };

  ##### NVIDIA bullshit | https://nixos.wiki/wiki/Nvidia
  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    # powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Do not disable this unless your GPU is unsupported or if you have a good reason to.
    open = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  #####

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pango = {
    isNormalUser = true;
    description = "Pangolecimal";
    extraGroups = ["networkmanager" "wheel"];
    # packages = with pkgs; [
    #	 # firefox
    #	 # thunderbird
    # ];
  };

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  # systemd.services."getty@tty1".enable = false;
  # systemd.services."autovt@tty1".enable = false;

  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # nixpkgs.config.brave.commandLineArgs = "--disable-features=WaylandFractionalScaleV1";

  # List packages installed in system profile.
  environment.systemPackages =
    (with unstable; [
      neovim
      vim
      wget
      git
      home-manager

      # kitty
      wezterm
      # nushell
      starship
      neofetch

      vscodium
      # libsForQt5.kate
      vlc
      # wl-clipboard
      xclip

      firefox
      thunderbird
      brave
      # chromium
      obsidian
      qownnotes
      # qbittorrent
      quartus-prime-lite
      # (pkgs.discord.override {
      #   # remove any overrides that you don't want
      #   withOpenASAR = true;
      #   withVencord = true;
      # })
      discord
      betterdiscordctl
      libreoffice
      unityhub

      nodejs
      yarn
      bun
      rustup
      # rust-analyzer
      gcc
      gnumake
      python312
      typescript
      zig
      go

      # temp vvv
      alejandra
      nil
      lua-language-server
      stylua
      gopls
      # temp ^^^

      # gimp-with-plugins
      # gimpPlugins.gmic
      # gmic-qt

      (catppuccin-gtk.override {
        accents = ["blue" "flamingo" "green" "lavender" "maroon" "mauve" "peach" "pink" "red" "rosewater" "sapphire" "sky" "teal" "yellow"];
        size = "compact";
        tweaks = ["rimless"];
        variant = "mocha";
      })

      appimage-run
      # wine-wayland

      eza
      bat
      ripgrep
      fzf
      zoxide
      fd
      manix

      # ani-cli
      # mpv
      # aria
      # yt-dlp
      # ffmpeg

      # woeusb
      trashy
      tmux
      lldb
      unzip
      tree-sitter
      # gnupg
      # pinentry

      # for pix-engine crate
      # SDL2
      # SDL2_image
      # SDL2_mixer
      # SDL2_mixer_2_0
      # SDL2_ttf
      # SDL2_gfx
    ])
    ++ (with pkgs; [
      ]);

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;
  environment.shells = with pkgs; [zsh];

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "23.05";
}
