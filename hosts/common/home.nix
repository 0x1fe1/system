{ ... }@inputs: {
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
      emoji = [ "Symbola" ];
      monospace = [ "FiraCode Nerd Font" ];
    };
  };

  home.file = { };

  home.sessionVariables = {
    EDITOR = "vim";
  };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
    };
  };
}
