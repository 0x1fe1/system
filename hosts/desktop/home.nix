{pkgs, ...}: {
  home.username = "pango";
  home.homeDirectory = "/home/pango";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # (jetbrains.idea-community)
    # blender
    (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
    brave
    corefonts
    fd
    file
    gnumake
    jq
    kdePackages.kate
    libreoffice
    obsidian
    ollama
    qemu
    quickemu
    trash-cli
    vlc
    wezterm
    wget
    xclip
    zig

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
