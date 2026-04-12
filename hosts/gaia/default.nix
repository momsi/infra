{ config, pkgs, lib, ... }:

{
  imports = [
    ../desktop.nix
    ./disko.nix
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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.opengl = {
    enable = true;
  };

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    open = false;
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Steam + Gaming
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        PIPEWIRE_NODE = "Game";
        PULSE_SINK = "Game";
        PROTON_ENABLE_HDR = "1";
        PROTON_ENABLE_WAYLAND = "1";
        PROTON_USE_NTSYNC = "1";
        PROTON_ENABLE_NVAPI = "1";
        DXVK_HDR = "1";
      };
    };
  };
  programs.gamemode.enable = true;

  # AppImage support for games
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

# Gaia-specific packages
  environment.systemPackages = with pkgs; [
    fastfetch
    vscodium
    python3
    opencode
    nodejs
  ];

  # ZRAM swap (replaces traditional swap)
  zramSwap.enable = true;
  swapDevices = [];

  # AMD CPU microcode
  hardware.cpu.amd.updateMicrocode = lib.mkDefault true;

  # Keyboard layout - German
  console.keyMap = "de";
  services.xserver.xkb.layout = "de";

  # Git configuration
  programs.git = {
    enable = true;
    config = {
      user.name = "momsi";
      user.email = "momsi@gaia";
      core.editor = "vim";
    };
  };
}