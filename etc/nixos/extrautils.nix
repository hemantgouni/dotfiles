{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.age
    pkgs.bc
    pkgs.bind
    pkgs.ffmpeg-full # ffmpeg only has the features depended on in nixpkgs
    pkgs.gnome-calculator
    pkgs.gnupg
    pkgs.hyperfine
    pkgs.imagemagick
    pkgs.inetutils
    pkgs.jq
    pkgs.keepassxc
    pkgs.krita
    pkgs.libsixel
    pkgs.lm_sensors
    pkgs.lsof
    pkgs.mpv
    pkgs.nixos-generators
    pkgs.nmap
    pkgs.openssl
    pkgs.pandoc
    pkgs.patchelf
    pkgs.pciutils
    pkgs.pdftk
    pkgs.psmisc
    pkgs.quarto
    pkgs.racket
    pkgs.smartmontools
    pkgs.speechd
    pkgs.tree
    pkgs.unzip
    pkgs.usbutils
    pkgs.virt-manager
    pkgs.watchexec
    pkgs.wget
    pkgs.xdg-utils
    pkgs.xorg.xlsclients
    pkgs.xournalpp
    pkgs.zbar
    pkgs.zip
  ];
}
