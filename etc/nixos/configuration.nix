# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, machineSpecific, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  # prevent processes running as the same user from reading each others'
  # memory
  boot.kernel.sysctl."kernel.yama.ptrace_scope" = 1;

  # Set your time zone.
  time.timeZone = "Etc/GMT";

  networking.firewall.enable = true;
  networking.nftables.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" "9.9.9.9" "149.112.112.112" ];
  # should contain a line of the form 'hostname = "<value>"'
  # TOML because it can't contain newlines, must be exact
  # this is desirable bc otherwise differing hostname across machines = merge conflicts
  networking.hostName =
    (builtins.fromTOML (builtins.readFile ./files/system/secure/hostname.toml)).hostname;

  services.resolved = {
    enable = true;
    llmnr = "false";
  };

  systemd.network = {
    enable = true;
    # systemd-networkd-wait-online.service will fail because iwd usually
    # manages our internet connection
    #
    # only enable for desktops, which should have a wired internet connection
    wait-online.enable = machineSpecific.isDesktop;
    networks = {
      "10-virt" = {
        matchConfig.Type = "ether";
        matchConfig.Virtualization = true;
        networkConfig.DHCP = "yes";
      };
      "10-desktop" = lib.mkIf machineSpecific.isDesktop {
        matchConfig.Type = "ether";
        networkConfig.DHCP = "yes";
      };
    };
  };

  networking.wireless.iwd.enable = true;
  # enable automatic dhcp for wireless networks
  networking.wireless.iwd.settings.General.EnableNetworkConfiguration = true;

  # wayland audio/video
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true;
  # This might be buggy?
  services.pipewire.pulse.enable = true;

  # enable wayland screen snooping
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # rootless containers
  virtualisation.podman.enable = true;

  # also enables QEMU/KVM
  virtualisation.libvirtd.enable = true;

  users.users = {
    lawabidingcactus = {
      isNormalUser = true;
      createHome = true;
      extraGroups = [ "wheel" "dialout" "audio" "docker" "libvirtd" "kvm" ];
      # generated using `mkpasswd -m sha-512`; useful for generated vms
      #
      # users are not managed declaratively by default, so this is just
      # the password used when no other has been imperatively set
      initialPassword = "password";
    };
  };

  # allows for smartcard functionality
  services.pcscd.enable = true;

  security.pam.u2f.authFile = ./files/system/secure/u2f_keys;
  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  services.atd.enable = true;
  programs.fish.enable = true;
  programs.sway.enable = true;
  programs.nix-ld.enable = true;

  fonts.fonts = with pkgs; [ cm_unicode bakoma_ttf ];

  # Allow non-root users to use ykpersonalize
  services.udev.packages = [ pkgs.yubikey-personalization ];

  environment.systemPackages = [
    # Manual dhcp for wired networks, and for vms built with nixos-rebuild switch build-vm
    # sudo dhcpcd <interface> should do it
    pkgs.dhcpcd
    # for alsa volume ctr
    pkgs.alsa-utils
    # for selecting output device
    pkgs.pavucontrol
    # for configurating printers
    pkgs.system-config-printer
    # for yubikey
    pkgs.yubikey-personalization
    pkgs.yubikey-manager
    pkgs.pam_u2f
  ];

  # Disable this when not in use because it starts a web server
  #
  # services.printing.enable = true;
  # services.printing.drivers = [ pkgs.gutenprint ];

  # services.opaque.enable = true;
  # services.opaque.database = ''{ mh_reg = { url = "mysql://mysql:mysql@127.0.0.1/mh_reg" } }'';

  # services.mysql.enable = true;
  # services.mysql.package = pkgs.mariadb;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the GNOME 3 Desktop Environment.
  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome3.enable = true;

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  #   firefox
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
