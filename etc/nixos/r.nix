{ pkgs, ... }:

{
  home.packages = [
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
  ];
}
