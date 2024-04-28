{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ../common/configuration.nix
  ];

  networking.hostName = "laptop";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  services.xserver.libinput.enable = true; # Enable touchpad support

  environment.systemPackages = with pkgs; [
  ];
}
