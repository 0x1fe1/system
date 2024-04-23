{pkgs, ...}: {
  home.packages = with pkgs; [
    ollama
    discord
    dotnetCorePackages.sdk_6_0
    # libgcc
    # gnumake
  ];

  imports = [
    ../common/home.nix
  ];
}
