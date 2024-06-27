{ config
, pkgs
, inputs
, ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    ../common/configuration.nix
  ];

  networking.hostName = "desktop"; # Define your hostname.

  # Enable automatic login for the user.
  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "pango";

  environment.systemPackages = with pkgs; [
    linuxHeaders
    gnumake
    gcc
  ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_9;

  # virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  # virtualisation.virtualbox.guest.enable = true;
  # virtualisation.virtualbox.guest.x11 = true;
  # users.extraGroups.vboxusers.members = ["pango"];

  services.udev.packages = [ pkgs.bazecor ];

  programs.steam.enable = true;

  ### Nvidia hax
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  ###
}
