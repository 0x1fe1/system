{pkgs, ...}: {
  home.username = "pango";
  home.homeDirectory = "/home/pango";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  home.file = {};

  home.packages = with pkgs; [
    # (jetbrains.idea-community)
    # ollama
    (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono" "Meslo" "Monaspace" "Noto" "NerdFontsSymbolsOnly"];})
    brave
    cool-retro-term
    corefonts
    fd
    file
    jq
    kdePackages.kate
    libreoffice
    networkmanager
    networkmanagerapplet
    nh
    nix-output-monitor
    obsidian
    protonvpn-gui
    qemu
    quickemu
    staruml
    vlc
    vscode
    xclip
    zsh-powerlevel10k

    (writeShellScriptBin "custom-system-edit" ''
      set -e
      pushd ~/system
      nix run ~/neovim .
      popd
    '')

    # to rebuild boot use:
    # $ NIXOS_INSTALL_BOOTLOADER=1 custom-system-rebuild
    (writeShellScriptBin "custom-system-rebuild" ''
      set -e
      pushd ~/system
      nh os switch
      current=$(nixos-rebuild list-generations --no-build-nix | grep current)
      git add . ; git commit --allow-empty -m "$(hostname)@system: $current"
      popd
    '')

    (writeShellScriptBin "custom-home-rebuild" ''
      set -e
      pushd ~/system
      nh home switch --configuration=$(hostname)
      current=$(nixos-rebuild list-generations --no-build-nix | grep current)
      git add . ; git commit --allow-empty -m "$(hostname)@home: $current"
      popd
    '')
  ];

  home.sessionVariables = {
    EDITOR = "vim";
  };

  programs = {
    zellij = {
      enable = true;
      enableZshIntegration = false;
      settings = {
        theme = "gruvbox-dark";
        copy_command = "xclip -selection clipboard";
        keybinds = {
          normal = {
            unbind = ["Ctrl h" "Ctrl s"];
            "bind \"Ctrl l\"" = {SwitchToMode = "Move";};
          };
        };
      };
    };

    wezterm = {
      enable = true;
      enableZshIntegration = false;
      extraConfig =
        /*
        lua
        */
        ''
          local w = require 'wezterm';

          local config = {}

          local FONT_ID = 1
          local FONT_ID_MAX = 4
          local FONTS = {
            "FiraCode Nerd Font",
            "JetBrainsMono Nerd Font",
            "MesloLGS NF",
            "Noto",
            "Consolas"
          }

          config = {
              color_scheme = "Catppuccin Mocha (Gogh)",
              font = w.font_with_fallback {
                  "FiraCode Nerd Font",
                  "JetBrainsMono Nerd Font",
                  "Consolas"
              },
              adjust_window_size_when_changing_font_size = false,
              warn_about_missing_glyphs = false,
              -- disable_default_key_bindings = true,
              hide_tab_bar_if_only_one_tab = true,
          }

          local opacity = 0.9
          config.window_background_opacity = opacity

          -- toggle function
          w.on("toggle-opacity", function(window, _)
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
          w.on("font-switch", function(window, _)
              local overrides = window:get_config_overrides() or {}
              FONT_ID = (FONT_ID % FONT_ID_MAX) + 1
              overrides.font = w.font(FONTS[FONT_ID])
              window:set_config_overrides(overrides)
          end)

          config.keys = {
              {
                  key = "O",
                  mods = "CTRL",
                  action = w.action.EmitEvent("toggle-opacity"),
              },
              {
                  key = "I",
                  mods = "CTRL",
                  action = w.action.EmitEvent("font-switch"),
              },
          }

          return config
        '';
    };

    zsh = {
      enable = true;

      shellAliases = {
        lla = "eza -Tla --icons -s=type";
        ll = "lla -L=1";
        ls = "ls --color";
        c = "clear";
        q = "exit";
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
          "--preview-window \"right,67%,wrap,~3\" --border=rounded"
          "--bind \"enter:become(nix run ~/neovim {})\""
        ];

        # [F]zf (fuzzy find)
        # [F]zf [F]unction (the underlying search directories function)
        ff = "fd . --type directory --max-depth=16 | fzf --border=rounded";
        f = "() { local dir=$(ff); [[ -n \"$dir\" && -d \"$dir\" ]] && cd \"$dir\" }";

        # nix-direnv
        da = "direnv allow";
        dn = "direnv deny";

        # [C]onfigure [N]ixos (goto ~/system and enter vim)
        cn = "custom-system-edit";
        # [F]lake rebuild [N]ixos (switch system with the new config)
        fn = "custom-system-rebuild";
        # [H]ome rebuild [N]ixos (switch home-manager with the new config)
        hn = "custom-home-rebuild";
      };

      initExtraFirst =
        /*
        bash
        */
        ''
          # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
          # Initialization code that may require console input (password prompts, [y/n]
          # confirmations, etc.) must go above this block; everything else may go below.
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
        '';

      initExtraBeforeCompInit =
        /*
        bash
        */
        ''
          # Set the directory we want to store zinit and plugins
          ZINIT_HOME="''${XDG_DATA_HOME:-''${HOME}/.local/share}/zinit/zinit.git"

          # Download Zinit, if it's not there yet
          if [ ! -d "$ZINIT_HOME" ]; then
             mkdir -p "$(dirname $ZINIT_HOME)"
             git clone https://github.com/zdharma-continuum/zinit.git --depth=1 "$ZINIT_HOME"
          fi

          # Source/Load zinit
          source "''${ZINIT_HOME}/zinit.zsh"

          # Add in Powerlevel10k
          zinit ice depth=1; zinit light romkatv/powerlevel10k

          # Add in zsh plugins
          zinit light zdharma-continuum/fast-syntax-highlighting
          zinit light zsh-users/zsh-completions
          zinit light zsh-users/zsh-autosuggestions
          zinit light Aloxaf/fzf-tab
        '';

      completionInit =
        /*
        bash
        */
        ''
          autoload -Uz compinit && compinit

          zinit cdreplay -q

          # To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        '';

      initExtra =
        /*
        bash
        */
        ''
          # History
          HISTSIZE=5000
          SAVEHIST=$HISTSIZE
          HISTFILE=~/.zsh_history
          HISTDUP=erase
          setopt appendhistory
          setopt sharehistory
          setopt hist_ignore_space
          setopt hist_ignore_all_dups
          setopt hist_save_no_dups
          setopt hist_ignore_dups
          setopt hist_find_no_dups

          # Completion styling
          zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
          zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
          zstyle ':completion:*' menu no
          zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -Ta --icons -L=1 -s=type $realpath'
          zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -Ta --icons -L=1 -s=type $realpath'

          # export DIRENV_LOG_FORMAT=
          # https://github.com/direnv/direnv/issues/68#issuecomment-1003426550

          # source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
          # source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh

          eval "$(fzf --zsh)"
          eval "$(zoxide init zsh)"
          eval "$(direnv hook zsh)"
          # source "/nix/store/m1njxh2kwbjxnpl7ykr9dxz7fsyrbamh-wezterm-20240203-110809-5046fc22/etc/profile.d/wezterm.sh"
        '';

      envExtra = ''
        export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
      '';
    };

    direnv = {
      enable = true;
      enableZshIntegration = false;
      nix-direnv.enable = true;
    };

    # starship = {
    #   enable = true;
    #   enableZshIntegration = false;
    #   settings = {
    #     scan_timeout = 10;
    #     directory = {
    #       truncate_to_repo = false;
    #       truncation_length = 64;
    #       truncation_symbol = "…/";
    #     };
    #     character.error_symbol = "[✖](bold red)";
    #     custom.direnv = {
    #       format = "[\\[direnv\\]]($style) ";
    #       style = "fg:yellow dimmed";
    #       when = "printenv DIRENV_FILE";
    #     };
    #   };
    # };

    zoxide = {
      enable = true;
      enableZshIntegration = false;
    };
    fzf = {
      enable = true;
      enableZshIntegration = false;
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
