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
    package = config.boot.kernelPackages.nvidiaPackages.latest;
  };

  # Explicitly include and load nvidia modules at boot
  boot.extraModulePackages = [ config.boot.kernelPackages.nvidiaPackages.latest ];
  boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  # Blacklist nouveau to prevent conflicts with nvidia
  boot.blacklistedKernelModules = [ "nouveau" ];

  # Enable DRM modesetting for nvidia-drm (required for Wayland)
  boot.kernelParams = [ "nvidia-drm.modeset=1" ];

  # Gaia-specific packages
  environment.systemPackages = with pkgs; [
    neofetch
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