{
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "pango";
  home.homeDirectory = "/home/pango";

  home.packages = [
    pkgs.hello
    (pkgs.nerdfonts.override {fonts = ["FiraCode"];})
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.file = {
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
      cd = "z";
      # :q = "exit";

      cn = "vim /home/pango/system/nixos/configuration.nix";
      fn = "sudo nixos-rebuild switch --flake /home/pango/system/#PangoliNix";
    };

    initExtraFirst = ''
        zstyle :compinstall filename '/home/pango/.zshrc'

        autoload -Uz compinit
        compinit

        eval "$(starship init zsh)"
        eval "$(zoxide init zsh)"
        eval "$(wezterm shell-completion --shell zsh)"
        source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
    '';

    # histSize = 10000;
    # histFile = "${config.xdg.dataHome}/zsh/history";

    zplug = {
      enable = true;
      plugins = [
        {name = "nix-community/nix-zsh-completions";}
        # {name = "zdharma-continuum/zsh-fast-syntax-highlighting";}
        {name = "zsh-users/zsh-autosuggestions";}
      ];
    };
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
}
