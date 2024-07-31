{ pkgs, ... }@inputs: {
  imports = [
    ../../modules/default.nix
  ];

  home.username = "pango";
  home.homeDirectory = "/home/pango";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      emoji = [ "Noto Emoji" ];
      monospace = [ "FiraCode Nerd Font" ];
    };
  };

  home.sessionVariables = {
    EDITOR = "vim";
  };
}
