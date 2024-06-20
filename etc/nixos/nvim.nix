{ config, pkgs, ... }:

{
  home.sessionVariables = {
    VISUAL = "nvim"; # see scripts.nix
    EDITOR = "${config.home.sessionVariables.VISUAL}";
    MANPAGER = "nvim +Man!";
    FZF_DEFAULT_COMMAND = "rg --files --hidden --follow";
    FZF_DEFAULT_OPTS = "--bind alt-j:down,alt-k:up";
  };

  programs.neovim = {

    enable = true;

    plugins = [
      (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: [
        plugins.bash
        plugins.c
        plugins.css
        plugins.fennel
        plugins.haskell
        plugins.html
        plugins.latex
        plugins.lua
        plugins.markdown
        plugins.markdown_inline
        plugins.nix
        plugins.ocaml
        plugins.python
        plugins.query
        plugins.racket
        plugins.rust
        plugins.vim
        plugins.vimdoc
      ]))
      pkgs.vimPlugins.conjure
      pkgs.vimPlugins.Coqtail
      pkgs.vimPlugins.fzf-vim
      pkgs.vimPlugins.gruvbox-nvim
      pkgs.vimPlugins.lean-nvim
      pkgs.vimPlugins.nvim-lspconfig
      pkgs.vimPlugins.nvim-treesitter-textobjects
      pkgs.vimPlugins.parinfer-rust
      pkgs.vimPlugins.supertab
      pkgs.vimPlugins.undotree
      pkgs.vimPlugins.vim-fugitive
    ];

    extraPackages = [
      pkgs.fzf
      pkgs.shellcheck
      pkgs.texlab
      pkgs.marksman
    ];

    withPython3 = true;
  };

  home.packages = [
    pkgs.my-fennel
    pkgs.fnlfmt
    pkgs.my-antifennel
  ];
}
