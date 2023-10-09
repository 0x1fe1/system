{
  # config,
  pkgs,
  # lib,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "pango";
  home.homeDirectory = "/home/pango";

  home.packages = [
    # pkgs.hello
    (pkgs.nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file = {
    ".config/nvim" = {
      recursive = true;
      source = pkgs.fetchFromGitHub {
        owner = "Pangolecimal";
        repo = "nvim";
        rev = "9fd68aabbb7a491fe1dcfa9f19c12605caf4f695";
        sha256 = "sha256-oRsyJfQUo3oJZ0I8uVBk1IChQBJXYUeMEweyU938EEk=";
      };
    };
  };

  home.stateVersion = "22.11";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Pangolecimal";
    userEmail = "domkuzaleza@gmail.com";
  };

  # programs.zsh.interactiveShellInit = "source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    shellAliases = {
      ll = "eza -FTla --icons -L=1 -s=type";
      ll2 = "eza -FTla --icons -L=2 -s=type";
      ll3 = "eza -FTla --icons -L=3 -s=type";
      lla = "eza -FTla --icons -s=type";
      v = "nvim";
      g = "z";
      # :q = "exit";

      cn = "z /home/pango/system && nvim .";
      fn = "sudo nixos-rebuild switch --flake /home/pango/system/#PangoliNix --impure";
    };

    initExtraFirst = ''
      zstyle :compinstall filename '/home/pango/.zshrc'

      autoload -Uz compinit
      compinit

      eval "$(starship init zsh)"
      eval "$(zoxide init zsh)"
      eval "$(wezterm shell-completion --shell zsh)"
      source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

      function precmd {
        print -Pn "\e[34m%~ \e[0m"
      }
    '';

    # histSize = 10000;
    # histFile = "${config.xdg.dataHome}/zsh/history";

    zplug = {
      enable = true;
      plugins = [
        {name = "nix-community/nix-zsh-completions";}
        # {name = "zdharma-continuum/zsh-fast-syntax-highlighting";}
        {name = "zsh-users/zsh-autosuggestions";}
        {name = "ziglang/shell-completions";}
      ];
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # viAlias = true;
    # vimAlias = true;
  };
}
