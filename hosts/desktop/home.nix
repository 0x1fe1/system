{pkgs, ...}: {
  home.packages = with pkgs; [
    discord
    dotnetCorePackages.sdk_6_0
  ];

  imports = [
    ../common/home.nix
  ];
}
