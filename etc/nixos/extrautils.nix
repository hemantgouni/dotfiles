{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.age
    pkgs.bc
    pkgs.bind
    pkgs.ffmpeg-full # ffmpeg-full has all features enabled; ffmpeg only has
                     # the subset depended on in nixpkgs 
    pkgs.gnome.gnome-calculator
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
    (pkgs.rstudioWrapper.override {
      packages = [
        pkgs.rPackages.dplyr
        pkgs.rPackages.ggplot2
        pkgs.rPackages.HistData
        pkgs.rPackages.lme4
        pkgs.rPackages.olsrr
        pkgs.rPackages.purrr
        pkgs.rPackages.rmarkdown
        pkgs.rPackages.stringr
        pkgs.rPackages.readr
      ];
    })
    pkgs.smartmontools
    pkgs.speechd
    pkgs.tree
    pkgs.unzip
    pkgs.usbutils
    pkgs.virt-manager
    pkgs.wget
    pkgs.xdg-utils
    pkgs.xorg.xlsclients
    pkgs.xournalpp
    pkgs.zbar
    pkgs.zip
  ];
}
