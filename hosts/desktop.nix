{ config, pkgs, lib, ... }:

{
  # Time and locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";

  # German keyboard layout in initrd (LUKS prompt)
  boot.initrd.preDeviceCommands = ''
    loadkeys de
  '';

  # Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # Firewall
  networking.firewall.enable = true;

  # Base packages
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
    curl
    keepassxc
    brave
  ];

  # Network
  networking.networkmanager.enable = true;

  # Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Display Manager (SDDM with autologin)
  services.xserver.enable = true;
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
    };
    autoLogin = {
      enable = true;
      user = "momsi";
    };
  };

  # KDE Plasma 6
  services.desktopManager.plasma6.enable = true;

  # XDG portal for Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Polkit
  security.polkit.enable = true;

  system.stateVersion = "25.11";
}