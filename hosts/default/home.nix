{pkgs, ...}: {
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
    discord
    (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})

    (jetbrains.idea-community)
    jdk21

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
    defaultKeymap = null;

    shellAliases = {
      lla = "eza -FTla --icons -s=type";
      ll = "lla -L=1";
      ":q" = "exit";

      # [G]oto (zoxide)
      g = "z";
      "g-" = "g -"; # [G]oto [-] (previous directory)
      "g." = "g .."; # [G]oto [.]./ (parent directory)
      gp = "g ~/personal"; # [G]oto [P]ersonal
      gs = "g ~/system"; # [G]oto [S]ystem
      gn = "g ~/neovim"; # [G]oto [N]eovim

      # [V]im (nvim built with nixvim)
      v = "nix run ~/neovim";
      "v." = "v ."; # [V]im [.] open vim in current directory
      # [V]im [F]zf (fuzzy find into vim)
      vf = "fd . -t f | fzf \
      --preview 'bat --color=always {}' --preview-window '~3' --border=rounded \
      --bind 'enter:become(nix run ~/neovim {})'";

      # [F]zf (fuzzy find)
      # [F]zf [F]unction (the underlying search directories function)
      ff = "fd . --type directory | fzf --border=rounded ";
      f = "() { local p; p=$(ff); [[ -n \"$p\" && -d \"$p\" ]] && cd \"$p\" }";

      # [C]onfigure [N]ixos (goto ~/system and enter vim)
      cn = "cd /home/pango/system && v .";
      # [F]lake rebuild [N]ixos (switch system with the new config)
      fn = "sudo nixos-rebuild switch --flake ~/system#default";
    };

    initExtra = ''
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    '';

    envExtra = ''
      export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
    '';

    zplug = {
      enable = true;
      plugins = [
        {name = "zdharma-continuum/fast-syntax-highlighting";}
        {name = "zsh-users/zsh-autosuggestions";}
      ];
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
      character.error_symbol = "[✖](bold red)";
    };
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };
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
