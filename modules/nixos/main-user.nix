{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.main-user;
in
  {
    options.main-user = {
      enable = lib.mkEnableOption "enable main user module";

      userName = lib.mkOption {
        default = "mainuser";
        description = ''
          username
        '';
      };
    };

    config = lib.mkIf cfg.enable {
      users.users.${cfg.userName} = {
        isNormalUser = true;
        description = "main user";
        extraGroups = ["networkmanager" "wheel"];
        shell = pkgs.zsh;
      };
    };
  }
  # Example usage:
  ''
    # configuration.nix
    {}: {
      imports = [
        # Include the results of the hardware scan.
        ./hardware-configuration.nix
        inputs.home-manager.nixosModules.default
        ../common/configuration.nix
        # ../../modules/nixos/main-user.nix
      ];

      # main-user.enable = true;
      # main-user.userName = "pango";
    };
  ''
