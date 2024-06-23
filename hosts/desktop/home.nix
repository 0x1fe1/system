{ pkgs, ... }: {
  home.packages = with pkgs; [
    # big ahh apps
    # jetbrains.idea-ultimate
    bazecor
    discord
    # obs-studio

    # langs
    dotnetCorePackages.sdk_6_0
    # jdk21_headless

    # sshpass
    # python3
    # ansible
    # ollama
    # libgcc
    # gnumake
    # appimage-run
    # kubernetes
    # kubectl
    # minikube
    # kompose
  ];

  imports = [
    ../common/home.nix
  ];
}
