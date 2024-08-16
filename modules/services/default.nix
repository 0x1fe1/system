{ ... }@inputs: {
  services.picom = {
    enable = true;
    backend = "glx";
    settings = {
      blur = {
        method = "gaussian";
        size = 10;
        deviation = 5.0;
      };
      blur-background-exclude = [
        "class_g != 'kitty'"
      ];
    };
  };
}
