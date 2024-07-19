{ pkgs, ... }@inputs:
let custom = import ./custom-scripts.nix { inherit pkgs; }; in {
  home.packages = with pkgs; [
    ### big ahh apps
    brave
    cool-retro-term
    floorp
    firefox
    gimp
    kdePackages.kate
    libreoffice
    obsidian
    # protonvpn-gui
    # staruml
    # vlc
    # vscode

    ### cli utils
    xclip
    fd
    file
    jq
    just
    man-pages
    networkmanager
    networkmanagerapplet
    nh
    nix-output-monitor
    tldr
    wgo
    ngrok
    distrobox
    # nix-prefetch
    # nix-prefetch-github
    # qemu
    # quickemu

    ### fonts
    fira-code
    fg-virgil
    noto-fonts-monochrome-emoji
    symbola
    corefonts
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "NerdFontsSymbolsOnly" ]; })

    ### hyprland
    # dunst
    # libnotify
    # swww
    # (pkgs.waybar.overrideAttrs (oldAttrs: {
    #   mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    # }))
    # networkmanagerapplet
    # rofi-wayland
    # tofi
    # grim # screenshot functionality
    # slurp # screenshot functionality
  ] ++ custom;
}
