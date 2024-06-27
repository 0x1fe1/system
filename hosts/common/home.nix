{ pkgs
, lib
, ...
}:
let
  shell-aliases-common = {
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
    jm = "j ~/mirea"; # [J]ump to [M]irea

    # [V]im (nvim built with nixvim)
    v = "nix run ~/neovim";
    "v." = "v ."; # [V]im [.] open vim in current directory

    # [F]zf [F]unction (the underlying search directories function)
    ff = "fd . --type directory --max-depth=16 | fzf --border=rounded";

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
  shell-functions-fish = {
    # [F]zf (fuzzy find)
    f = {
      body = /* fish */ ''
        set dir (ff);
        if test -n $dir -a -d $dir
          cd $dir
        end
      '';
    };
    # [V]im [F]zf (fuzzy find into vim)
    vf = {
      body = with builtins; concatStringsSep " " (filter (v: isString v) (split "\n" /*bash*/''
        fd . -t f
        | fzf --preview "bat --color=always {}"
        --preview-window "right,67%,wrap,~3" --border=rounded
        --bind "enter:become(nix run ~/neovim {})"
      ''));
    };
  };
in
{
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

  home.file = { };

  home.packages = with pkgs; [
    # big ahh apps
    brave
    cool-retro-term
    kdePackages.kate
    libreoffice
    obsidian
    # protonvpn-gui
    # staruml
    # vlc
    # vscode

    # cli utils
    xclip
    fd
    file
    jq
    just
    man-pages
    networkmanager
    networkmanagerapplet
    nh
    nix-output-monitor
    tldr
    wgo
    ngrok
    distrobox
    # nix-prefetch
    # nix-prefetch-github
    # qemu
    # quickemu

    # fonts
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" ]; })
    # font-awesome
    # corefonts
    fg-virgil
    noto-fonts-monochrome-emoji
    symbola

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

  home.shellAliases = shell-aliases-common;

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
      extraConfig = builtins.readFile ./../../dots/wezterm.lua;
    };

    kitty = {
      enable = true;
      theme = "Tokyo Night";
    };

    fish = {
      enable = true;
      # shellAliases = shell-aliases-common;
      functions = shell-functions-fish;
      plugins = [
        { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      ];
      shellInitLast = ''
        set -gx FZF_DEFAULT_COMMAND "fd --type f --strip-cwd-prefix"
        set -gx DIRENV_LOG_FORMAT ""
        set -U fish_greeting
        complete -e j
      '';
    };

    bash = {
      enable = true;
    };

    carapace = {
      enable = true;
    };

    oh-my-posh = {
      enable = true;
      settings = builtins.fromTOML (builtins.unsafeDiscardStringContext (builtins.readFile ./../../dots/ohmyposh.toml));
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    zoxide.enable = true;
    fzf.enable = true;
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
