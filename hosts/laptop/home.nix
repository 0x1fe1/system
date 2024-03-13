{pkgs, ...}: {
  home.username = "pango";
  home.homeDirectory = "/home/pango";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # manix
    # ngrok
    # thunderbird
    # times-newer-roman
    # vlc
    # vscodium
    (jetbrains.idea-community)
    (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
    brave
    corefonts
    fd
    firefox
    gradle
    jdk21
    kdePackages.kate
    libreoffice
    neofetch
    ollama
    qemu
    quickemu
    staruml
    wezterm
    xclip

    (writeShellScriptBin "custom-system-rebuild" ''
      set -e
      pushd ~/system
      sudo nixos-rebuild switch --flake ~/system#laptop
      current=$(nixos-rebuild list-generations --no-build-nix | grep current)
      git add . ; git commit -m "laptop: $current"
      popd
    '')
  ];

  imports = [
    ../common/home.nix
  ];
}
