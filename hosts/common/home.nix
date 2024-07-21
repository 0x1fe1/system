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

  home.file = { };

  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = "Mod4";
      terminal = "kitty";
      defaultWorkspace = "workspace number 1";
      menu = "${pkgs.rofi}/bin/rofi -show drun -show-icons";
      bars = [ ];
      startup = [ ];
      workspaceOutputAssign = [ ];
      colors = { };
      floating = { };
      focus = { };
      gaps = { };
      window = { };
    };
  };

  programs.i3status = {
    enable = true;
    general = {
      colors = true;
      color_good = "#a6e3a1";
      color_degraded = "#f9e2af";
      color_bad = "#f38ba8";
      interval = 1;
    };
  };

  services.picom = {
    enable = true;
    backend = "glx";
    activeOpacity = 0.9;
    settings = {
      blur =
        {
          method = "gaussian";
          size = 10;
          deviation = 5.0;
        };
    };
  };
}
