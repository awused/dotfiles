set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

source ~/.vimrc

if has('nvim-0.5')
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

require 'colorizer'.setup({
  '*';
  rust = {
    names = false,
  }
}, {
  RRGGBBAA = true,
  rgb_fn = true,
  hsl_fn = true,
})

EOF
endif
