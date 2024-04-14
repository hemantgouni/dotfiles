{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "hemant";
  home.homeDirectory = "/home/hemant";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";

  imports = [
    ./agda.nix
    ./bash.nix
    ./direnv.nix
    ./extrautils.nix
    ./firefox.nix
    ./foot.nix
    ./fuzzel.nix
    ./gammastep.nix
    ./git.nix
    ./htop.nix
    ./icons.nix
    ./man.nix
    ./nvim.nix
    ./readline.nix
    ./rg.nix
    ./r.nix
    ./scripts.nix
    ./sioyek.nix
    ./ssh.nix
    ./sway.nix
    ./texlive.nix
    ./utop.nix
  ];
}
