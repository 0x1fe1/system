{pkgs, ...}: {
  home.username = "pango";
  home.homeDirectory = "/home/pango";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # (jetbrains.idea-community)
    (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
    brave
    corefonts
    fd
    file
    jq
    kdePackages.kate
    libreoffice
    obsidian
    ollama
    qemu
    quickemu
    vlc
    wget
    xclip

    (writeShellScriptBin "custom-system-rebuild" ''
      set -e
      pushd ~/system
      sudo nixos-rebuild switch --flake ~/system#desktop
      current=$(nixos-rebuild list-generations --no-build-nix | grep current)
      git add . ; git commit -m "desktop: $current"
      popd
    '')
  ];

  imports = [
    ../common/home.nix
  ];
}
