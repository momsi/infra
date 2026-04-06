{ config, pkgs, lib, hyprland, ... }:

{
  imports = [
    ../desktop.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "gaia";

  # User
  users.users.momsi = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    # hashedPassword = "$6$..."; # Use: openssl passwd -6 <password>
    password = "p4ssw0rd"; # placeholder
  };

  # Boot (system-specific)
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
  };
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.reusePassphrases = true;

  # NVIDIA GPU (system-specific)
  hardware.enableRedistributableFirmware = true;
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Gaia-specific packages
  environment.systemPackages = with pkgs; [
    neofetch
  ];
}