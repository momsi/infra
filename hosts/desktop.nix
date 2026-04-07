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
    kitty
    fuzzel
    waybar
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

  # Display Manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${pkgs.hyprland}/bin/Hyprland";
        user = "greeter";
      };
    };
  };

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      "$terminal" = "kitty";
      "$menu" = "fuzzel";
      "$mainMod" = "SUPER";
      exec-once = [ "waybar" ];
      bind = [
        "$mainMod, Return, exec, $terminal"
        "$mainMod, Space, exec, $menu"
        "$mainMod, Q, killactive,"
        "$mainMod, F, fullscreen,"
        "$mainMod SHIFT, M, exit,"
        "$mainMod, V, togglefloating,"
        "ALT, Tab, cyclenext,"
      ];
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };

  # XDG portal for Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Polkit
  security.polkit.enable = true;

  system.stateVersion = "25.11";
}