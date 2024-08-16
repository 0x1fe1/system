{ pkgs, ... }: {
  home.packages = with pkgs; [
    (jetbrains.idea-community)
    # bazecor
    jdk21
    # manix
    # ngrok
    # thunderbird
    # times-newer-roman
    # vlc
    # vscodium
    firefox
    gradle
    neofetch
    ngrok
  ];

  imports = [
    ../../modules/device-common/home.nix
  ];
}
