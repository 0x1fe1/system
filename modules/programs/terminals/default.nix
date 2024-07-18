{ ... }@inputs: {
  programs = {
    wezterm = {
      enable = true;
      extraConfig = builtins.readFile ./wezterm.lua;
    };

    kitty = {
      enable = true;
      theme = "Tokyo Night";
      extraConfig = builtins.readFile ./kitty.conf;
    };
  };
}
