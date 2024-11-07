{ config, pkgs, ... }:

{
  home.sessionVariables = {
    HISTCONTROL = "ignoreboth";
    PROMPT_DIRTRIM = "2";
  };

  programs.bash = {
    enable = true;
    shellAliases = {
      d = "pushd";
      b = "popd";
      c = "clear";
      f = "ls";
      e = "nvim";
    };
    # login only
    profileExtra = ''
      if [[ "$-" == *i* && "$(tty)" == '/dev/tty1' ]]; then
          exec sway
      fi
    '';

    # interactive only
    # do NOT run external commands (non-shell builtins) here! for cleanliness
    initExtra = let
      red = ''\e[1;31m'';
      green = ''\e[1;32m'';
      clear = ''\e[m'';
      improperExit = ''$(if [ "$?" -eq 0 ]; then printf "${green}"; else printf "${red}"; fi)'';
      ssh = ''$([ -n "$SSH_TTY" ] && printf "%s " "\h")'';
      jobs = ''$([ "\j" -gt 0 ] && printf "%s " "\j")'';
      workdir = ''\w'';
    in
    # improperExit must be first, so job status isn't changed
    ''
      PS1='${improperExit}${ssh}${jobs}${workdir} ⊢${clear} '
    '';
  };
}
