{
  # config,
  # lib,
  pkgs,
  unstable,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "pango";
  home.homeDirectory = "/home/pango";

  # List packages installed in system profile.
  home.packages = [];

  home.sessionVariables = {EDITOR = "nvim";};

  home.file = {};

  home.stateVersion = "23.05";

  programs.home-manager.enable = true;

  programs.java = {
    enable = true;
    package = unstable.jdk;
  };

  programs.git = {
    enable = true;
    userName = "Pangolecimal";
    userEmail = "domkuzaleza@gmail.com";
    package = unstable.git;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    shellAliases = {
      ll = "eza -FTla --icons -L=1 -s=type";
      ll2 = "eza -FTla --icons -L=2 -s=type";
      ll3 = "eza -FTla --icons -L=3 -s=type";
      lla = "eza -FTla --icons -s=type";
      v = "nix run /home/pango/.config/nvim/#nvim";
      "v." = "v .";
      g = "z";
      "g." = "g ..";
      ":q" = "exit";
      ":x" = "exit";
      ":xa" = "exit";
      f = "z $(fd . --hidden --exclude \".git\" | fzf)";

      cn = "z /home/pango/system && v .";
      fn = "sudo nixos-rebuild switch --flake /home/pango/system/#PangoliNix --impure";
    };

    initExtraFirst = ''
      zstyle :compinstall filename '/home/pango/.zshrc'

      autoload -Uz compinit && compinit
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

      eval "$(starship init zsh)"
      eval "$(zoxide init zsh)"
      eval "$(wezterm shell-completion --shell zsh)"

      function precmd {
        print -Pn "\e[34m%~ \e[0m"
      }
    '';
    # source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

    # histSize = 10000;
    # histFile = "${config.xdg.dataHome}/zsh/history";

    zplug = {
      enable = true;
      plugins = [
        {name = "zsh-users/zsh-autosuggestions";}
        {name = "ziglang/shell-completions";}
        {name = "nix-community/nix-zsh-completions";}
        {name = "zdharma-continuum/fast-syntax-highlighting";}
      ];
    };
  };
}
