{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.texlive.combined.scheme-full
  ];

  # see latexmk -showextraoptions for a full list of options
  # pdf_mode = 4 sets lualatex as the default latex implementation
  home.file.".latexmkrc".text = ''
    $pdf_mode = 4;
    $out_dir = ".tex_out";
  '';
}
