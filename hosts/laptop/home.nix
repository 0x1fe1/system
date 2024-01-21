{pkgs, ...}: let
  on-zsh = {
    enable = true;
    enableZshIntegration = true;
  };
in {
  home.username = "pango";
  home.homeDirectory = "/home/pango";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fd
    wezterm
    brave
    kate
    xclip
    (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})

    (jetbrains.idea-community)
    jdk21

    ollama
    neofetch
    ngrok
    manix
    vscodium
    vlc
    firefox
    thunderbird
    libreoffice
    times-newer-roman

    # (writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.wezterm = {
    enable = true;
    enableZshIntegration = true;
    extraConfig = ''
      local w = require("wezterm")

      return {
          color_scheme = "Catppuccin Mocha",
          font = w.font("FiraCode Nerd Font"),

          window_background_opacity = 0.9,
          adjust_window_size_when_changing_font_size = false,
          warn_about_missing_glyphs = false,
      }
    '';
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    # defaultKeymap = "emacs";

    /*
    TODO Aliases:

    [G]oto (zoxide)
        [.] ../ (parent directory)
        [P]ersonal
        [N]ixos
        [V]im

    [F]uzzy Find (fzf)
        []  ./ (current directory)
        [n] manix (github:mlvzk/manix) # ?

    [V]im
        [.] (current directory)

    */
    shellAliases = {
      ll = "eza -FTla --icons -s=type -L=1";
      ll2 = "eza -FTla --icons -s=type -L=2";
      ll3 = "eza -FTla --icons -s=type -L=3";
      lla = "eza -FTla --icons -s=type";
      v = "nix run /home/pango/neovim";
      "v." = "v .";
      g = "z";
      "g." = "z ..";
      ":q" = "exit";
      ":x" = "exit";
      ":xa" = "exit";
      f = "z $(fd . --hidden --exclude \".git\" | fzf)";

      cn = "cd /home/pango/system && v .";
      fn = "sudo nixos-rebuild switch --flake /home/pango/system#laptop";
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      scan_timeout = 10;
      directory = {
        truncate_to_repo = false;
        truncation_length = 64;
        truncation_symbol = "…/";
      };
      character = {
        error_symbol = "[✖](bold red)";
      };
    };
  };

  programs.zoxide = on-zsh;
  programs.fzf = on-zsh;
  programs.ripgrep.enable = true;
  programs.eza.enable = true;
  programs.bat.enable = true;

  programs.git = {
    enable = true;
    userName = "Pangolecimal";
    userEmail = "domkuzaleza@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
}
