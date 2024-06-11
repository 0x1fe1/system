{ pkgs, ... }: {
  home.packages = with pkgs; [
    wgo
    jetbrains.idea-ultimate
    jdk21_headless
    delta

    bazecor
    sshpass
    tldr
    # python3
    # ansible
    ollama
    ngrok
    discord
    dotnetCorePackages.sdk_6_0
    # libgcc
    # gnumake
    obs-studio
    appimage-run

    kubernetes
    kubectl
    minikube
    kompose
  ];

  imports = [
    ../common/home.nix
  ];
}
