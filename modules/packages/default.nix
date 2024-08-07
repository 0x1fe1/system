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
    # nix-prefetch
    # nix-prefetch-github
    # qemu
    # quickemu
    distrobox
    fd
    file
    fossil
    jq
    just
    maim # screenshot
    man-pages
    networkmanager
    networkmanagerapplet
    ngrok
    nh # nixos-rebuild wrapper
    nix-output-monitor
    playerctl # media
    tldr
    universal-ctags
    wgo
    xclip
    xorg.xbacklight # screen brightness
    xorg.xf86inputsynaptics # touchpad

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
