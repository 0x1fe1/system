{pkgs, ...}: {
  home.packages = with pkgs; [
    (jetbrains.idea-community)
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
  ];

  imports = [
    ../common/home.nix
  ];
}
