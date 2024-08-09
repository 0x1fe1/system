{ ... }@inputs:
let
  aliases = import ./aliases.nix;
in
{
  programs = {
    bash.enable = true;
    fish = {
      enable = true;
      functions = aliases.shell-functions-fish;
      shellAliases = aliases.shell-aliases-common;
      # plugins = [
      #   { name = "fzf-fish"; src = pkgs.fishPlugins.fzf-fish.src; }
      #   # { name = "fzf"; src = pkgs.fishPlugins.fzf.src; }
      # ];
      interactiveShellInit = /*fish*/ ''
        complete -c v -w 'nix run ~/neovim' -e
      '';
      shellInitLast = /*fish*/ ''
        set -gx FZF_DEFAULT_COMMAND "fd --type f --strip-cwd-prefix"
        set -gx DIRENV_LOG_FORMAT ""
        set -U fish_greeting
      '';
    };

    oh-my-posh = {
      enable = true;
      settings = builtins.fromTOML (builtins.unsafeDiscardStringContext (builtins.readFile ./ohmyposh.toml));
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
    feh.enable = true;
  };
}
