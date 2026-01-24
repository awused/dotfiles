set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

source ~/.vimrc

if has('nvim-0.5')
lua <<EOF
-- require('lazy').setup({
--   'nvim-treesitter/nvim-treesitter',
--   lazy = false,
--   build = ':TSUpdate'
-- })
--
require'nvim-treesitter'.install {
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
}

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
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
  callback = function() vim.treesitter.start() end,
})

-- require'nvim-treesitter.configs'.setup {
--   ensure_installed = {
--       "bash",
--       "c",
--       "cpp",
--       "css",
--       "go",
--       "gomod",
--       "html",
--       "javascript",
--       "json",
--       "lua",
--       "python",
--       "regex",
--       "scss",
--       "rust",
--       "toml",
--       "typescript",
--       "yaml",
--   },
--   highlight = {
--     enable = true,
--   },
-- }

require 'colorizer'.setup{
  filetypes = {
    '*';
    rust = {
      names = false,
    },
  },
  user_default_options = {
    names = false,
    RRGGBBAA = true,
    rgb_fn = true,
    hsl_fn = true,
  },
}

if vim.g.os == 'Linux' then
require"gruvbox".setup{
  terminal_colors = false, -- add neovim terminal colors
  undercurl = true,
  underline = true,
  bold = true,
  italic = {
    strings = true,
    emphasis = true,
    comments = true,
    operators = false,
    folds = true,
  },
  strikethrough = true,
  invert_selection = false,
  invert_signs = false,
  invert_tabline = false,
  invert_intend_guides = false,
  inverse = false, -- invert background for search, diffs, statuslines and errors
  contrast = "", -- can be "hard", "soft" or empty string
  palette_overrides = {
    light1 = "#ffffff",
  },
  overrides = {
    TabLineFill = {bg = "NONE"}
  },
  dim_inactive = false,
  transparent_mode = true,
}

vim.cmd('colorscheme gruvbox')

end

EOF
endif

if g:os == "Linux"
hi BufTabLineCurrent guibg=NONE ctermbg=NONE guifg=#c8b9a4 ctermfg=white
hi BufTabLineHidden guibg=NONE ctermbg=NONE guifg=#555555
hi BufTabLineFill guibg=NONE ctermbg=NONE guifg=#555555
hi BufTabLineActive guibg=NONE ctermbg=NONE guifg=#c8b9a4 ctermfg=white
hi CocHighlightText ctermfg=cyan guifg=cyan
endif
