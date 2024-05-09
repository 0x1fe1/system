{pkgs, ...}: {
  home.packages = with pkgs; [
    bazecor
    sshpass
    tldr
    python3
    ansible
    ollama
    ngrok
    discord
    dotnetCorePackages.sdk_6_0
    # libgcc
    # gnumake
  ];

  imports = [
    ../common/home.nix
  ];
}
