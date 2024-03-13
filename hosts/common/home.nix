{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  home.file = {};

  home.packages = with pkgs; [
    (writeShellScriptBin "custom-system-edit" ''
      set -e
      pushd ~/system
      nix run ~/neovim .
      popd
    '')
  ];

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
          local wezterm = require 'wezterm';

          local config = {}

          config = {
              color_scheme = "Catppuccin Mocha",
              font = wezterm.font_with_fallback {
                  "FiraCode Nerd Font",
                  "JetBrainsMono Nerd Font",
                  "Consolas"
              },
              adjust_window_size_when_changing_font_size = false,
              warn_about_missing_glyphs = false,
          }

          local opacity = 0.9
          config.window_background_opacity = opacity

          -- toggle function
          wezterm.on("toggle-opacity", function(window, _)
              local overrides = window:get_config_overrides() or {}
              if not overrides.window_background_opacity then
                  -- if no override is setup, override the default opacity value with 1.0
                  overrides.window_background_opacity = 1.0
              else
                  -- if there is an override, make it nil so the opacity goes back to the default
                  overrides.window_background_opacity = nil
              end
              window:set_config_overrides(overrides)
          end)

          config.keys = {
              {
                  key = "O",
                  mods = "CTRL",
                  action = wezterm.action.EmitEvent("toggle-opacity"),
              },
          }

          return config
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
        cn = "custom-system-edit";
        # [F]lake rebuild [N]ixos (switch system with the new config)
        fn = "custom-system-rebuild";
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
        init = {
          defaultBranch = "main";
        };
      };
    };
  };
}
