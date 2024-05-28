{ pkgs, ... }:

let
  # not currently using this but will keep it around
  writeFennelScriptBin = binary-name: script-path:
    (pkgs.stdenv.mkDerivation {
      name = binary-name;
      # since we don't define a source attribute, we're just directly
      # getting files as input
      #
      # will get an error otherwise
      dontUnpack = true;
      nativeBuildInputs = [
        # pkgs.my-fennel just adds readline support, so no need to use it here
        pkgs.fennel
      ];
      buildInputs = [
        pkgs.luajit
      ];
      installPhase = ''
        printf '#!${pkgs.luajit}/bin/lua\n' > tmp.lua
        fennel --compile ${script-path} >> tmp.lua
        chmod +x tmp.lua
        mkdir -p $out/bin
        mv tmp.lua $out/bin/${binary-name}
      '';
    });
in
{
  home.packages = [
    (pkgs.writeShellScriptBin
      "update"
      (builtins.readFile ./files/scripts/update.sh))
    (pkgs.writeShellScriptBin
      "compile-nvim-conf"
      (builtins.readFile ./files/scripts/compile-nvim-conf.sh))
    (pkgs.writeShellScriptBin
      "sync-dots"
      (builtins.readFile ./files/scripts/sync-dots.sh))
    (pkgs.writeShellScriptBin
      "danger-anti-sync-dots"
      (builtins.readFile ./files/scripts/danger-anti-sync-dots.sh))
    (pkgs.writeShellScriptBin
      "nvim-remote"
      (builtins.readFile ./files/scripts/nvim-remote.sh))
  ];
}
