{ pkgs
, lib
, ...
}: {
  home.username = "pango";
  home.homeDirectory = "/home/pango";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;

  home.file = { };

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "Meslo" "Monaspace" "Noto" "NerdFontsSymbolsOnly" ]; })
    brave
    cool-retro-term
    corefonts
    fd
    fg-virgil
    file
    jq
    kdePackages.kate
    libreoffice
    man-pages
    networkmanager
    networkmanagerapplet
    nh
    nix-output-monitor
    nix-prefetch
    nix-prefetch-github
    obsidian
    protonvpn-gui
    qemu
    quickemu
    staruml
    vlc
    vscode
    xclip

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
        theme = lib.mkForce "gruvbox-dark";
        copy_command = "xclip -selection clipboard";
        keybinds = {
          normal = {
            unbind = [ "Ctrl h" "Ctrl s" ];
            "bind \"Ctrl l\"" = { SwitchToMode = "Move"; };
          };
        };
      };
    };

    wezterm = {
      enable = true;
      enableZshIntegration = false;
      extraConfig = /* lua */ ''
        local config = {}

        local FONT_ID = 0
        local FONTS = {
          "FiraCode Nerd Font",
          "JetBrainsMono Nerd Font",
        }

        config = {
          color_scheme = "Catppuccin Mocha (Gogh)",
          harfbuzz_features = {"cv02", "cv25", "cv26", "cv27", "cv28", "cv32", "ss03", "ss05", "ss07", "ss09"},
          font = wezterm.font_with_fallback {
            "FiraCode Nerd Font",
            "JetBrainsMono Nerd Font",
          },
          adjust_window_size_when_changing_font_size = false,
          warn_about_missing_glyphs = false,
          -- disable_default_key_bindings = true,
          -- hide_tab_bar_if_only_one_tab = true,
          window_decorations = "INTEGRATED_BUTTONS|RESIZE",

          -- Backend settings
          prefer_egl=true,
          -- front_end="OpenGL",
          webgpu_power_preference = "HighPerformance",

          -- Experimental undocumented features to improve perceived performance
          -- default delay is 3ms
          mux_output_parser_coalesce_delay_ms = 1,
          -- default size is 256
          glyph_cache_image_cache_size = 512,
          -- default size is 1024
          shape_cache_size = 2048,
          line_state_cache_size = 2048,
          line_quad_cache_size = 2048,
          line_to_ele_shape_cache_size = 2048,
          -- default is 10 fps for animations
          animation_fps = 60,
          -- default is 60
          max_fps = 144,

          -- Set terminal type for better integration
          term = "wezterm",
        }

        local opacity = 0.95
        config.window_background_opacity = opacity

        -- toggle function
        wezterm.on("toggle-opacity", function(window, _)
          local overrides = window:get_config_overrides() or {}
          if not overrides.window_background_opacity then
            overrides.window_background_opacity = 1.0
          else
            overrides.window_background_opacity = nil
          end
          window:set_config_overrides(overrides)
        end)
        wezterm.on("font-switch", function(window, _)
          local overrides = window:get_config_overrides() or {}
          FONT_ID = (FONT_ID + 1) % #FONTS
          overrides.font = wezterm.font(FONTS[FONT_ID+1])
          window:set_config_overrides(overrides)
        end)

        config.keys = {
          {
            key = "O",
            mods = "CTRL",
            action = wezterm.action.EmitEvent("toggle-opacity"),
          },
          {
            key = "I",
            mods = "CTRL",
            action = wezterm.action.EmitEvent("font-switch"),
          },
        }

        return config
      '';
    };

    zsh = {
      enable = true;
      defaultKeymap = "emacs";
      # zprof.enable = true;

      plugins = [
        {
          name = "fast-syntax-highlighting";
          src = pkgs.fetchFromGitHub {
            owner = "zdharma-continuum";
            repo = "fast-syntax-highlighting";
            rev = "cf318e06a9b7c9f2219d78f41b46fa6e06011fd9";
            hash = "sha256-RVX9ZSzjBW3LpFs2W86lKI6vtcvDWP6EPxzeTcRZua4=";
          };
        }
        # {
        #   name = "zsh-completions";
        #   src = pkgs.fetchFromGitHub {
        #     owner = "zsh-users";
        #     repo = "zsh-completions";
        #     rev = "b1cf65187047a83e27a0847bd565dcf28b5be465";
        #     hash = "sha256-eqpZp61qCrdp6yrexQJWgEl9Efjk/aTj/AImplpl6gg=";
        #   };
        # }
        {
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "c3d4e576c9c86eac62884bd47c01f6faed043fc5";
            hash = "sha256-B+Kz3B7d97CM/3ztpQyVkE6EfMipVF8Y4HJNfSRXHtU=";
          };
        }
        {
          name = "fzf-tab";
          src = pkgs.fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "c7fb028ec0bbc1056c51508602dbd61b0f475ac3";
            hash = "sha256-Qv8zAiMtrr67CbLRrFjGaPzFZcOiMVEFLg1Z+N6VMhg=";
          };
        }
      ];

      initExtra = /* bash */ ''
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

        # Custom Keybindings
        bindkey '^j' history-search-backward
        bindkey '^k' history-search-forward

        # Completion styling
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"
        zstyle ':completion:*' menu no
        zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -Ta --icons -L=1 -s=type $realpath'
        zstyle ':fzf-tab:complete:z:*' fzf-preview 'eza -Ta --icons -L=1 -s=type $realpath'

        export DIRENV_LOG_FORMAT=""
        # https://github.com/direnv/direnv/issues/68#issuecomment-1003426550
      '';

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

      envExtra = ''
        export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
      '';

      completionInit = "autoload -U compinit && compinit";
    };

    oh-my-posh = {
      enable = true;
      enableZshIntegration = true;
      settings = builtins.fromTOML (builtins.unsafeDiscardStringContext (builtins.readFile ./../../dots/ohmyposh.toml));
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
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
      userName = "0x1fe1";
      userEmail = "pangolecimal@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };

      delta = {
        enable = true;
        options = {
          features = "decorations";
          dark = true;
          line-numbers = true;
          side-by-side = false;
          true-color = "always";
          decorations = {
            commit-decoration-style = "lightblue ol";
            commit-style = "raw";
            file-style = "omit";
            hunk-header-decoration-style = "lightblue box";
            hunk-header-file-style = "pink";
            hunk-header-line-number-style = "lightgreen";
            hunk-header-style = "file line-number syntax";
          };
          interactive = {
            keep-plus-minus-markers = false;
          };
        };
      };
    };
  };
}
