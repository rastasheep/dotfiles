# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, noctalia, mango, ... }:

{
  imports = [
    ./hardware-configuration.nix
    mango.nixosModules.mango
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # X11 not needed - MangoWC is a Wayland compositor
  # services.xserver.enable = true;

  # Wayland compositor requirements
  # Enable seat management for proper device access (keyboard, mouse, GPU)
  services.seatd.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.rastasheep = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "seat" ]; # Enable 'sudo', GPU access, and seat management
    packages = with pkgs; [
      tree
    ];
  };

  # programs.firefox.enable = true;

  # Enable MangoWC Wayland compositor
  programs.mango.enable = true;

  # Graphics and rendering support for Wayland compositors
  hardware.graphics = {
    enable = true;
    # Add Mesa drivers explicitly for virtio GPU 3D acceleration
    extraPackages = with pkgs; [
      mesa
      mesa.drivers
      virglrenderer
    ];
  };

  # Ensure proper OpenGL/Mesa environment for Wayland compositors
  environment.variables = {
    # Use software rendering fallback if hardware acceleration fails
    LIBGL_ALWAYS_SOFTWARE = "0";
    # Enable Mesa debugging if needed
    # MESA_DEBUG = "1";
    # EGL_LOG_LEVEL = "debug";
  };

  # System packages
  environment.systemPackages = [
    # Noctalia shell panel/widget system
    noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  # Enable services required by Noctalia
  hardware.bluetooth.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Spice guest toold for UTM 
  services.spice-vdagentd.enable = true;
  services.qemuGuest.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # Enable Nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

