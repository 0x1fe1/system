{pkgs, ...}: {
  home.packages = with pkgs; [
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
