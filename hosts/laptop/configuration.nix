{ config
, pkgs
, inputs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/device-common/configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  networking.hostName = "laptop";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.xserver.libinput.enable = true; # Enable touchpad support

  environment.systemPackages = with pkgs; [
  ];
}
