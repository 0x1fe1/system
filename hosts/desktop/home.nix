{pkgs, ...}: {
  home.packages = with pkgs; [
    cool-retro-term
    ollama
    ngrok
    discord
    dotnetCorePackages.sdk_6_0
    # libgcc
    # gnumake
  ];

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "gruvbox-dark";
    };
  };

  imports = [
    ../common/home.nix
  ];
}
