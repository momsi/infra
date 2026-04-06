{ config, pkgs, ... }:

{
  # Time and locale
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";

  # User
  users.users.momsi = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };

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
  ];

  system.stateVersion = "25.05";
}