set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

source ~/.vimrc

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {
      "bash",
      "c",
      "cpp",
      "css",
      "go",
      "gomod",
      "html",
      "javascript",
      "json",
      "lua",
      "python",
      "regex",
      "scss",
      "rust",
      "toml",
      "typescript",
      "yaml",
  },
  highlight = {
    enable = true,
  },
}
EOF
