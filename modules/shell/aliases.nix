{
  shell-aliases-common = {
    lla = "eza -Tl -s=type --no-user --no-time";
    ll = "lla -L=1";
    ls = "ls --color";
    c = "clear";
    q = "exit";
    ":q" = "exit";

    # [J]ump to (zoxide)
    # j = "z";
    # "j-" = "j -"; # [J]ump to [-] (previous directory)
    # "j." = "j .."; # [J]ump to [.]./ (parent directory)
    # jp = "j ~/personal"; # [J]ump to [P]ersonal
    # js = "j ~/system"; # [J]ump to [S]ystem
    # jn = "j ~/neovim"; # [J]ump to [N]eovim
    # jm = "j ~/mirea"; # [J]ump to [M]irea

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
}
