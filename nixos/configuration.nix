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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "pango";

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

  ##### NVIDIA bullshit ~~ Google: NixOS NVIDIA
  # Make sure opengl is enabled
  hardware.opengl = {
    enable = true;
    driSupport = true;
  };

  # NVIDIA drivers are unfree
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
    ];

  # Tell Xorg to use the nvidia driver
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    # for wayland
    modesetting.enable = true;

    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # maybe fix for black sceen after suspend?
  # hardware.nvidia.prime = {
  #   sync.enable = true;
  #   nvidiaBusId = "PCI:1:0:0";
  #   intelBusId = "PCI:0:2:0";
  # };
  # hardware.nvidia.powerManagement.enable = true;
  #
  # systemd.services.nvidia-resume.serviceConfig = {
  #   ExecStartPost = "${pkgs.xorg.xrandr}/bin/xrandr --display :0.0 --auto";
  # };
  # services.xserver.displayManager.sessionCommands = ''
  #   ${pkgs.xorg.xhost}/bin/xhost +local:
  # '';
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

  nix.settings.experimental-features = ["nix-command" "flakes"];

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

      kitty
      wezterm
      nushell
      starship
      neofetch

      vscodium
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
      # quartus-prime-lite
      # (pkgs.discord.override {
      #   # remove any overrides that you don't want
      #   withOpenASAR = true;
      #   withVencord = true;
      # })
      discord
      betterdiscordctl

      nodejs
      deno
      yarn
      bun
      nodePackages_latest.pnpm
      rustup
      # rust-analyzer
      gcc
      gnumake
      python312
      zig
      zls

      # fuck mason
      stylua
      luajitPackages.lua-lsp
      lua-language-server
      nodePackages_latest.vscode-css-languageserver-bin
      nodePackages_latest.svelte-language-server
      nodePackages_latest.typescript-language-server
      typescript
      nodePackages_latest.prettier
      prettierd
      vscode-langservers-extracted
      nil # nix
      alejandra # nix
      marksman

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
