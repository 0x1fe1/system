{pkgs, ...}: {
  home.username = "pango";
  home.homeDirectory = "/home/pango";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    fd
    wezterm
    brave
    libsForQt5.kate
    xclip
    (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})

    (jetbrains.idea-community)
    jdk21
    gradle
    qemu
    quickemu

    ollama
    neofetch
    # ngrok
    # manix
    # vscodium
    # vlc
    firefox
    # thunderbird
    libreoffice
    # times-newer-roman
    corefonts
    staruml

    # (writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  fonts.fontconfig.enable = true;

  home.file = {};

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs = {
    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig =
        /*
        lua
        */
        ''
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

    zsh = {
      enable = true;
      enableAutosuggestions = true;
      enableCompletion = true;
      defaultKeymap = null;

      shellAliases = {
        lla = "eza -Tla --icons -s=type";
        ll = "lla -L=1";
        c = "clear";
        ":q" = "exit";

        # [J]ump to (zoxide)
        j = "z";
        "j-" = "j -"; # [J]ump to [-] (previous directory)
        "j." = "j .."; # [J]ump to [.]./ (parent directory)
        jp = "j ~/personal"; # [J]ump to [P]ersonal
        js = "j ~/system"; # [J]ump to [S]ystem
        jn = "j ~/neovim"; # [J]ump to [N]eovim
        jm = "j ~/mirea"; # [J]ump to [N]eovim

        # [V]im (nvim built with nixvim)
        v = "nix run ~/neovim";
        "v." = "v ."; # [V]im [.] open vim in current directory
        # [V]im [F]zf (fuzzy find into vim)
        vf = toString [
          "fd . -t f"
          "| fzf --preview \"bat --color=always {}\""
          "--preview-window \"~3\" --border=rounded"
          "--bind \"enter:become(nix run ~/neovim {})\""
        ];

        # [F]zf (fuzzy find)
        # [F]zf [F]unction (the underlying search directories function)
        ff = "fd . --type directory --max-depth=3 | fzf --border=rounded";
        f = "() { local dir=$(ff); [[ -n \"$dir\" && -d \"$dir\" ]] && cd \"$dir\" }";

        # [C]onfigure [N]ixos (goto ~/system and enter vim)
        cn = "pushd ~/system ; v . ; popd";
        # [F]lake rebuild [N]ixos (switch system with the new config)
        fn = toString [
          "pushd ~/system ;"
          "sudo nixos-rebuild switch --flake ~/system#laptop ;"
          "git add . ; git commit -m \"laptop: $(nixos-rebuild list-generations --no-build-nix | grep current)\" ;"
          "popd"
        ];
      };

      initExtra =
        /*
        bash
        */
        ''
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

          # ~~~~~ Direnv ~~~~~
          # Tone down verbosity of loading output
          # https://github.com/direnv/direnv/issues/68#issuecomment-1003426550
          copy_function() {
            test -n "$(declare -f "$1")" || return
            eval "''${_/$1/$2}"
          }
          copy_function _direnv_hook _direnv_hook__old
          _direnv_hook() {
            _direnv_hook__old "$@" 2> >(awk '{if (length >= 200) { sub("^direnv: export.*","direnv: export "NF" environment variables")}}1')
            wait
          }
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

    direnv = {
      enable = true;
      enableZshIntegration = true; # see note on other shells below
      nix-direnv.enable = true;
    };

    starship = {
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

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    ripgrep.enable = true;
    eza.enable = true;
    bat.enable = true;

    git = {
      enable = true;
      userName = "Pangolecimal";
      userEmail = "domkuzaleza@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };
    };
  };
}
