{pkgs, ...}: {
  home.username = "pango";
  home.homeDirectory = "/home/pango";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # (jetbrains.idea-community)
    # ollama
    (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
    brave
    corefonts
    discord
    dotnetCorePackages.sdk_6_0
    fd
    file
    jq
    kdePackages.kate
    libreoffice
    networkmanager
    networkmanagerapplet
    obsidian
    protonvpn-gui
    qemu
    quickemu
    staruml
    vlc
    vscode-fhs
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
