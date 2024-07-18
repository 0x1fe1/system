{ lib, ... }@inputs: {
  programs = {
    zellij = {
      enable = true;
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

    git = {
      enable = true;
      userName = "0x1fe1";
      userEmail = "pangolecimal@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
      };

      aliases = {
        ignore = ''!gi() { curl -sL https://www.toptal.com/developers/gitignore/api/$@ ;}; gi'';
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
