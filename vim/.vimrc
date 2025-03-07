" ~/.vimrc
" vim: set foldmethod=marker foldlevel=0:
"
" Need to compile vim with python support (editors/vim with CONSOLE mode
" selected)
"
" install dash, libclang (included with llvm past 40), llvm50 (or higher),
" boost-all, boost-python-libs, fzf, python-dev, python3-dev
"
" python -m ensurepip
" pip install yapf
"
" Be sure to set clang-format for Glaive for formatting
"
"
" npm install -g typescript js-beautify yarn
"
" install yapf for python
"
" Plug commands: PlugInstall, PlugUpdate, PlugClean, PlugUpgrade (vim-plug
" itself)
" Set g:plug_timeout to large value if necessary

" Manually apply https://github.com/rust-lang/rust.vim/pull/448/commits/ce431a00633d924bd4781cdff493226d6eb65d1f
" Line ~160 goes from 'call setline(1, l:content)' to 'call nvim_buf_set_lines(0, 0, -1, v:true, l:content)'

" --- REMINDER --- Also need to set Glaive
let g:os = substitute(system('uname'), '\n', '', '')
if g:os == "FreeBSD"
  let $LD_LIBRARY_PATH .= ':/usr/local/llvm80/lib/'
endif

let mapleader = " "

"{{{ Key Bindings
" :rrc -> reload vimrc
" . fold
" <F4> NerdTreeToggle
" <F5> UndoTreeToggle
" :Nnum and :Num hides/shows numbers

" Eunuch
" :SudoWrite
" :SudoEdit -- full e replacement, no syntax
" :Sudoe -- Current buffer only, working syntax
" :Delete
" :Move
" :Rename (:Move relative to the file)

" vim/surround
" cs/ds to surround things
" cs1w( brackets the next word

" Buffers
" <leader>b Buffergator
" <leader>m FZF search buffers
" <leader>UP/DOWN/LEFT/WRITE split and open MRU buffer in split
" <leader>0-9 to switch to numbered buffer
" <leader>v <number> to switch to a numbered buffer
" <leader>d close buffer without closing window
" <leader>c close window without closing buffer, doesn't risk :q last window
" <leader>D reopen last closed buffer

" tcomment
" gcc comment this line
" gc4j to toggle comments for next four lines
" <leader>_p to comment paragraph

" YouCompleteMe
" <leader>g -> GoTo
" <leader>r -> GoToReferences
" <leader>f -> FixIt
" <leader>o -> OrganizeImports - different style, but removes unused imports
" :RR <newname> -> RefactorRename

" FZF + ripgrep/bfs searching
" :S <search> or <leader>s <search> to grep file content for <search>, then fuzzy match
" <C-p> to just search current project for files
" <C-q> search home for files
" <C-s> search $SOURCE_DIR for files
" <C-d> search nas home for files
" :M or <leader>m search buffers
" S uses a whitelist of extensions and excludes some directories

" >< in html/js/ts -> complete html tag
" ><CR> to autocomplete and start new line
" </ to close tag

" Standard vim refresher - https://github.com/TheNaoX/vimtutor/blob/master/vimtutor
" yit/cit/dit/vit - in tag
" yat/cat/dat/vat - around tag

" Alt + Arrow keys to switch panes

" Terminal stuff
" This is not interactive
" :term <commands>
" https://github.com/vim/vim/blob/master/runtime/doc/terminal.txt
"}}}
"{{{ Custom Functions
" https://stackoverflow.com/questions/3878692/aliasing-a-command-in-vim
fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

fun! RemoveBG(target)
  exec 'hi '.a:target.' guibg=NONE ctermbg=NONE'
endfun

function! PromptInput(command)
  call inputsave()
  let l:input = input(a:command.' ')
  call inputrestore()
  execute a:command.' '.l:input
endfunction

fun! CreateDirectoryIfMissing(dir)
  if !isdirectory(a:dir)
    call mkdir(a:dir, "p")
  endif
endfun

" Finding the root directory of the project, if any
" Modified from https://github.com/jremmen/vim-ripgrep/blob/master/plugin/vim-ripgrep.vim
fun! s:RgMakePath(dirs, dir)
  return '/'.join(a:dirs[0:index(a:dirs, a:dir)], '/')
endfun

fun! s:RgHasFile(path)
  return filereadable(a:path) || isdirectory(a:path)
endfun

fun! ProjectRoot()
  let l:cwd = getcwd()
  "let l:dirs = split(getcwd(), '/')
  " Look for the project root of the current file, not current directory
  let l:dirs = split(expand('%:p:h'), '/')

  for l:dir in reverse(copy(l:dirs))
    for l:type in ['.git']
      let l:path = s:RgMakePath(l:dirs, l:dir)
      if s:RgHasFile(l:path.'/'.l:type)
        return l:path
      endif
    endfor
  endfor
  return l:cwd
endfun

fun! GrepDir(dir, ...)
  let l:cwdb = getcwd()
  exe 'lcd '.a:dir
  call call("fzf#vim#grep", a:000)
  exe 'lcd '.l:cwdb
endfun

fun! GrepDirAbs(dir, cmd, ...)
  if !empty($FZF_CTRL_T_COMMAND)
    let l:cmd = $FZF_CTRL_T_COMMAND . ' -not \( -path ''*/go/bin/*'' -prune \) ' . a:dir . ' | awk ''{print $0":1:1"}'''
    call call("fzf#vim#grep", [l:cmd] + a:000)
  elseif !empty($FZF_DEFAULT_COMMAND)
    let l:cmd = $FZF_DEFAULT_COMMAND . ' -not \( -path ''*/go/bin/*'' -prune \) ' . a:dir . ' | awk ''{print $0":1:1"}'''
    call call("fzf#vim#grep", [l:cmd] + a:000)
  endif
endfun

fun! Sudoe()
  execute "SudoEdit"
  doautocmd filetypedetect BufReadPost
endfun
"}}}

packadd! matchit

"{{{ vim-plug
if empty(glob('$HOME/.vim/autoload/plug.vim'))
  silent !curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
"}}}
"{{{ Plugins
call plug#begin('$HOME/.vim/plugged')
"{{{ Buffer Management
"{{{ BufTabLine Settings
let g:buftabline_numbers = 2
let g:buftabline_indicators = 1
nmap <leader>1 <Plug>BufTabLine.Go(1)
nmap <leader>2 <Plug>BufTabLine.Go(2)
nmap <leader>3 <Plug>BufTabLine.Go(3)
nmap <leader>4 <Plug>BufTabLine.Go(4)
nmap <leader>5 <Plug>BufTabLine.Go(5)
nmap <leader>6 <Plug>BufTabLine.Go(6)
nmap <leader>7 <Plug>BufTabLine.Go(7)
nmap <leader>8 <Plug>BufTabLine.Go(8)
nmap <leader>9 <Plug>BufTabLine.Go(9)
nmap <leader>0 <Plug>BufTabLine.Go(10)
"}}}

Plug 'ap/vim-buftabline'
Plug 'jeetsukumaran/vim-buffergator'

" By default bufkill creates a lot of <leader>b mappings
let g:BufKillCreateMappings = 0
nnoremap <leader>d :BD<cr>
nnoremap <leader>D :BUNDO<cr>:e<cr>
Plug 'qpkorr/vim-bufkill'
"}}}
"{{{ Language Plugins
if !has('nvim-0.5')
  Plug 'leafgarland/typescript-vim'
  Plug 'othree/yajs.vim'
  Plug 'othree/es.next.syntax.vim'
  let g:python_highlight_all = 1
  let g:python_recommended_style = 0
  Plug 'vim-python/python-syntax'
  Plug 'tmhedberg/SimpylFold'
  let g:yapf_style = "google"
  Plug 'google/yapf', { 'rtp': 'plugins/vim', 'for': 'python' }

  let g:go_highlight_functions = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_fields = 1
  let g:go_highlight_types = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_build_constraints = 1
  " let g:go_fmt_command = "goimports"
  let g:go_fmt_autosave = 0
  " Remember fold state after write
  " let g:go_fmt_experimental = 1
endif

if has('nvim')
  " :MarkdownPreview
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
  let g:mkdp_auto_start = 0
  let g:mkdp_auto_close = 1
endif

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
let g:rustfmt_autosave = 1
if executable('rustup')
  let g:rustfmt_command = "rustfmt +nightly "
endif
" clippy will compile things if they're new, and we want to stick with mold
" for debug mode.
if g:os == "Linux" && executable('mold')
  let $MOLD_PATH = "mold"
  let $LD_PRELOAD = "/usr/lib64/mold/mold-wrapper.so"
endif
Plug 'rust-lang/rust.vim'

if has('nvim-0.5')
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
endif

Plug 'petRUShka/vim-opencl'
"}}}
"{{{ Autocompletion
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  let l:options='--js-completer'
  if executable('clang-format')
    let l:options=l:options . ' --clang-completer'
  endif
  if executable('go')
    let l:options=l:options . ' --go-completer'
  endif
  if executable('rustc')
    let l:options=l:options . ' --rust-completer'
  endif
  echom l:options
  if a:info.status == 'installed' || a:info.status == 'updated' || a:info.force
    " !./install.py --clang-completer --go-completer --js-completer
    call system('./install.py ' . l:options)
  endif
endfunction
if has('nvim')
  let g:ale_linters = {'rust': ['rustc', 'rust-analyzer']}
  let g:ale_rust_cargo_use_clippy = executable('cargo-clippy')
  let g:ale_disable_lsp = 1
  " Plug 'dense-analysis/ale'

  " Morons
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  " Plug 'neoclide/coc.nvim', {'commit': 'bdfd169', 'do': 'yarn install --frozen-lockfile'}
  " Plug 'neoclide/coc.nvim', {'commit': '3dc6153', 'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-tsserver', {'do': 'yarn install --frozen-lockfile'}
  Plug 'josa42/coc-sh', {'do': 'yarn install --frozen-lockfile'}
  Plug 'josa42/coc-go', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-html', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-json', {'do': 'yarn install --frozen-lockfile'}
  Plug 'fannheyward/coc-pyright', {'do': 'yarn install --frozen-lockfile'}
  Plug 'fannheyward/coc-rust-analyzer', {'do': 'yarn install --frozen-lockfile'}
  Plug 'clangd/coc-clangd', {'do': 'yarn install --frozen-lockfile'}
  Plug 'fannheyward/coc-markdownlint', {'do': 'yarn install --frozen-lockfile'}
  Plug 'neoclide/coc-css', {'do': 'yarn install --frozen-lockfile'}
else
  Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
endif
"}}}
"{{{ Navigation / Search
"{{{ FZF Searching
let g:rgf_command = '
  \ rg --column --line-number --no-heading --fixed-strings --smart-case --no-ignore --hidden --follow --color "always" --max-count 10
  \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf,ts,dart,toml,scss,css,sass,yaml,h,rs}"
  \ -g "!**/{.git,node_modules,vendor,dist,.sass-cache,.vim}/*" '

" Ripgrep in --files mode is still faster than find
let g:rgs_command = '
  \ rg --files --no-ignore --column --no-heading --hidden --follow  --color "always"
  \ -g "!**/{.git,node_modules,vendor,.sass-cache,.vim}/*" | awk ''{print $1":1:1"}'''

" Steal the default command from FZF's environment variables
" TODO -- It'd be nice to get rid of awk here
if !empty($FZF_DEFAULT_COMMAND)
  let g:rgs_command = $FZF_DEFAULT_COMMAND . ' -not \( -path ''*/go/bin/*'' -prune \) | awk ''{print $0":1:1"}'''
endif
if !empty($FZF_CTRL_T_COMMAND)
  let g:rgs_command = $FZF_CTRL_T_COMMAND . ' -not \( -path ''*/go/bin/*'' -prune \) | awk ''{print $0":1:1"}'''
endif

command! -bang -nargs=* S call GrepDir(ProjectRoot(), g:rgf_command .shellescape(<q-args>), 1, <bang>0)
call SetupCommandAlias("M", "Buffers")
nnoremap <C-p> :call GrepDir(ProjectRoot(), g:rgs_command, 0, 0)<cr>
nnoremap <C-q> :call GrepDirAbs($HOME, 0, 0)<cr>
nnoremap <C-s> :call GrepDirAbs($SOURCE_DIR, 0, 0)<cr>
nnoremap <C-d> :call GrepDirAbs($NASHOME, 0, 0)<cr>
nnoremap <leader>m :Buffers<cr>
nnoremap <leader>s :call PromptInput(":S")<cr>
"}}}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
"Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
" Plug 'justinmk/vim-sneak'
Plug 'unblevable/quick-scope'
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

" nnoremap <F4> :NERDTreeToggle<cr>
" Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
"}}}
"{{{ Tmux
if !exists("g:loaded_bracketed_paste")
  let s:loaded_tmux_focus_events=1
  Plug 'tmux-plugins/vim-tmux-focus-events'
else
  if !exists("s:loaded_tmux_focus_events")
    echo "ERROR: loaded bracketed_paste before tmux-focus-events, fix your vimrc"
    echom "ERROR: loaded bracketed_paste before tmux-focus-events, fix your vimrc"
  endif
endif
Plug 'christoomey/vim-tmux-navigator'
"}}}
"{{{ Code Formatting

fun! s:ShouldFormat() abort
  return wordcount().bytes < 2000000 && expand('%:p') !~# '\V'.$THIRD_PARTY_SOURCE && expand('%:p') !~# '\V/usr/ports' && expand('%:p') !~# '\V'.$HOME.'/.vim/plugged' && expand('%:p') !~# '\V'.$HOME.'/HoloCure'
endfun

augroup autoformat_settings
  autocmd!
  " autocmd FileType bzl if s:ShouldFormat() | exe 'AutoFormatBuffer buildifier' | endif
  autocmd FileType c,cpp,proto,javascript,typescript if s:ShouldFormat() | exe 'AutoFormatBuffer clang-format' | endif
  " autocmd FileType dart if s:ShouldFormat() | exe 'AutoFormatBuffer dartfmt' | endif
  " autocmd FileType gn if s:ShouldFormat() | exe 'AutoFormatBuffer gn' | endif
  autocmd FileType go if s:ShouldFormat() | exe 'AutoFormatBuffer gofmt' | endif
  autocmd FileType html,css,scss,sass,less,json if s:ShouldFormat() | exe 'AutoFormatBuffer js-beautify' | endif
  " autocmd FileType java if s:ShouldFormat() | exe 'AutoFormatBuffer google-java-format' | endif
  autocmd FileType python if s:ShouldFormat() | exe 'AutoFormatBuffer yapf' | endif
  " Alternative: autocmd FileType python if s:ShouldFormat() | exe 'AutoFormatBuffer autopep8' | endif
augroup END


Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
"}}}
"{{{ Copying and Pasting
let g:highlightedyank_highlight_duration = 2000
Plug 'machakann/vim-highlightedyank'
if !has('nvim')
  Plug 'roxma/vim-tmux-clipboard'
endif
" This needs to be loaded after vim-tmux-focus-events
Plug 'ConradIrwin/vim-bracketed-paste'
" Make pasting fast
" https://github.com/liskin/dotfiles/blob/home/.vim/plugin/fastpaste.vim
function! s:paste_toggled(new, old) abort
  if a:new && !a:old
    let b:saved_foldexpr = &foldexpr
    let &l:foldexpr = ''
    let b:saved_syntax = &syntax
    let &l:syntax = 'off'
  elseif !a:new && a:old && exists('b:saved_foldexpr')
    let &l:foldexpr = b:saved_foldexpr
    let &l:syntax = b:saved_syntax
    unlet b:saved_foldexpr
    unlet b:saved_syntax
  endif
endfunc

augroup FastPaste
  autocmd!
  autocmd OptionSet paste call s:paste_toggled(v:option_new, v:option_old)
augroup END
"}}}

nnoremap <F5> :UndotreeToggle<cr>
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-characterize'

" Prefer vividchalk in 256 colour mode, but gruvbox highlights much more
let g:gruvbox_contrast_dark="hard"
" Italics would be nice if FreeBSD ever updates ncurses
if g:os == "Linux"
  let g:gruvbox_italic=1
endif
if has('nvim')
  Plug 'ellisonleao/gruvbox.nvim'
else
  Plug 'morhetz/gruvbox'
endif

" Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
" Plug 'rebelot/kanagawa.nvim'
" Plug 'lifepillar/vim-solarized8'
" Plug 'altercation/vim-colors-solarized'
"Plug 'tpope/vim-vividchalk'
Plug 'agude/vim-eldar'
if has('nvim')
  Plug 'NvChad/nvim-colorizer.lua'
endif
call plug#end()
"{{{ YouCompleteMe Settings
if !has('nvim')
  " Disable preview entirely
  set completeopt-=preview
  let g:ycm_global_ycm_extra_conf = $HOME.'/.ycm_extra_conf.py'
  let g:ycm_add_preview_to_completeopt=0
  " let g:ycm_autoclose_preview_window_after_completion=1

  let g:ycm_filetype_specific_completion_to_disable = {
    \ 'vim' : 1,
    \ 'help' : 1,
    \ 'vimrc' : 1,
    \ 'zsh' : 1,
    \ 'xml' : 1,
    \ 'html' : 1,
    \ '' : 1,
    \}

  " The following is a hack to make the carriage return key function as the
  " 'accept' action when using YouCompleteMe plugin for autocompletion
  " See https://github.com/Valloric/YouCompleteMe/issues/232#issuecomment-299677328
  imap <expr> <CR> pumvisible() ? "\<c-y>" : "\<CR>"

  nnoremap <leader>g :YcmCompleter GoTo<cr>
  nnoremap <leader>r :YcmCompleter GoToReferences<cr>
  " Disabled in favour of googlefmt
  "nnoremap <leader>f :YcmCompleter Format<cr>
  nnoremap <leader>f :YcmCompleter FixIt<cr>
  nnoremap <leader>o :YcmCompleter OrganizeImports<cr>
  call SetupCommandAlias("RR", "YcmCompleter RefactorRename")
endif
"}}}
"{{{ CoC.vim Settings
if has('nvim')
  " inoremap <silent><expr> <TAB>
  "       \ pumvisible() ? coc#_select_confirm() :
  "       \ <SID>check_back_space() ? "\<TAB>" :
  "       \ coc#refresh()
  " inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#confirm():
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
  " inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

  function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  inoremap <silent><expr> <c-space> coc#refresh()

  " Make <CR> auto-select the first completion item and notify coc.nvim to
  " format on enter, <cr> could be remapped by other vim plugin
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  " Use `[g` and `]g` to navigate diagnostics
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " GoTo code navigation.
  nmap <silent> <leader>g <Plug>(coc-definition)
  nmap <silent> <leader>y <Plug>(coc-type-definition)
  nmap <silent> <leader>i <Plug>(coc-implementation)
  nmap <silent> <leader>r <Plug>(coc-references)

  " Highlight the symbol and its references when holding the cursor.
  function! s:cursor_hold()
    if exists('*CocActionAsync')
      call CocActionAsync('highlight')
    endif
  endfunction
  autocmd CursorHold * silent call s:cursor_hold()

  " Symbol renaming.
  nmap <leader>n <Plug>(coc-rename)
  " Applying codeAction to the selected region.
  " Example: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap keys for applying codeAction to the current cursor.
  nmap <leader>ac  <Plug>(coc-codeaction-cursor)
  nmap <leader>al  <Plug>(coc-codeaction-line)
  " Apply AutoFix to problem on the current line.
  nmap <leader>f  <Plug>(coc-fix-current)

  function! s:coc_float_scroll(amount) abort
    let float = coc#util#get_float()
    if !float | return '' | endif
    let buf = nvim_win_get_buf(float)
    let buf_height = nvim_buf_line_count(buf)
    let win_height = nvim_win_get_height(float)
    if buf_height < win_height | return '' | endif
    let pos = nvim_win_get_cursor(float)
    try
      let last_amount = nvim_win_get_var(float, 'coc_float_scroll_last_amount')
    catch
      let last_amount = 0
    endtry
    if a:amount > 0
      if pos[0] == 1
        let pos[0] += a:amount + win_height - 2
      elseif last_amount > 0
        let pos[0] += a:amount
      else
        let pos[0] += a:amount + win_height - 3
      endif
      let pos[0] = pos[0] < buf_height ? pos[0] : buf_height
    elseif a:amount < 0
      if pos[0] == buf_height
        let pos[0] += a:amount - win_height + 2
      elseif last_amount < 0
        let pos[0] += a:amount
      else
        let pos[0] += a:amount - win_height + 3
      endif
      let pos[0] = pos[0] > 1 ? pos[0] : 1
    endif
    call nvim_win_set_var(float, 'coc_float_scroll_last_amount', a:amount)
    call nvim_win_set_cursor(float, pos)
    return ''
  endfunction

  let g:coc_snippet_next = '<c-l>'
  let g:coc_snippet_prev = '<c-h>'
  inoremap <silent><expr> <c-down> coc#float#has_scroll() ? coc#float#scroll(1) : "\<c-down>"
  inoremap <silent><expr> <c-up> coc#float#has_scroll() ? coc#float#scroll(0) : "\<c-up>"
  " vnoremap <silent><expr> <c-j> coc#util#has_float() ? <SID>coc_float_scroll(1) : "\<c-j>"
  " vnoremap <silent><expr> <c-k> coc#util#has_float() ? <SID>coc_float_scroll(-1) : "\<c-k>"

  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
endif
"}}}
"}}}

call glaive#Install()
Glaive codefmt plugin[mappings]
if g:os == "FreeBSD"
  Glaive codefmt clang_format_executable="clang-format80"
endif
Glaive codefmt gofmt_executable="goimports"
"{{{ Clang Format
Glaive codefmt clang_format_style="{
  \ BasedOnStyle: Google,
  \  ColumnLimit: 0 }"
"}}}
"{{{ Filetype Settings
function! s:CompleteTags()
  inoremap <buffer> >< ></<C-x><C-o><Esc>:startinsert!<CR><C-O>?</<CR>
  inoremap <buffer> ><CR> ></<C-x><C-o><Esc>:startinsert!<CR><C-O>?</<CR><CR><Tab><CR><Up><C-O>$
  inoremap <buffer> </ </<C-x><C-o><Esc>:startinsert!<CR><C-O>?</<CR>
endfunction

augroup filetype_settings
  autocmd!
  autocmd FileType python setlocal softtabstop=4 shiftwidth=4 tabstop=4
  autocmd FileType rust setlocal softtabstop=4 shiftwidth=4
  autocmd FileType markdown setlocal softtabstop=2 shiftwidth=2
  autocmd FileType go setlocal noexpandtab nosmarttab tabstop=2
  autocmd FileType go nnoremap <buffer> <Leader>l :GoLint<cr>
  autocmd BufRead,BufNewFile *.html,*.js,*.ts,*.xml,*.ui call s:CompleteTags()
augroup END
"}}}
"{{{ Custom Commands and Keybinds
command! Nnum set nonumber | set norelativenumber
command! Num set number | set relativenumber
command! Sudoe call Sudoe()
call SetupCommandAlias("rrc", "so ~/.vimrc")
call SetupCommandAlias("W", "w")
nnoremap <Leader>v :ls<CR>:b<Space>
nnoremap <leader>c <C-w>c
nnoremap . za
nnoremap <leader>. za
noremap <A-Right> <C-w><Right>
noremap <A-Left> <C-w><Left>
noremap <A-Down> <C-w><Down>
noremap <A-Up> <C-w><Up>
"}}}
"{{{ Settings
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
let &t_ZH="\<Esc>[3m"
let &t_ZR="\<Esc>[23m"

set background=dark
set nohlsearch
set expandtab
set smarttab
set shiftwidth=2
set softtabstop=2
set autoindent
set number
set relativenumber
set mouse=a
set hidden
set foldlevelstart=20
set backspace=indent,eol,start
set modeline
set smartcase
set encoding=utf8
set fillchars+=vert:│
set fillchars+=fold:─
set fileencodings=ucs-bom,utf-8,sjis
set ignorecase
set smartcase
set showtabline=0

if has('nvim')
  " https://github.com/neoclide/coc.nvim/issues/4511
  " set foldexpr=nvim_treesitter#foldexpr()
  " set foldmethod=expr
  set laststatus=0
else
  set foldmethod=syntax
  set ttymouse=sgr
endif

set updatetime=300
if has('nvim-0.5')
  set signcolumn=number
endif

"set notimeout
" Handle escape character timeouts
set timeout
set timeoutlen=100000 ttimeoutlen=10

if executable('dash')
  set shell=dash
elseif executable('bash')
  set shell=bash
endif

augroup window_settings
  autocmd!
  " Highlight once past 100 characters. Works out well for half of my monitors.
  autocmd BufWinEnter *\.* call matchadd('ColorColumn', '\%>100v.')
  autocmd BufWinEnter *\.* highlight ExtraWhitespace ctermbg=red guibg=red
  "autocmd BufWinEnter * call matchadd('ExtraWhitespace', '\s\+$', 11)
  autocmd BufWinEnter *\.* call matchadd('ExtraWhitespace', '\s\+\%#\@<!$')
  " Don't do sync syntax on large files
  autocmd BufWinEnter *\.* if line2byte(line("$") + 1) > 1000000 | syntax sync clear | endif
  autocmd BufWinEnter *\.* if line2byte(line("$") + 1) > 1000000 | set foldmethod=manual | endif
augroup END

" Use X clipboard if we can
if has('clipboard')
  set clipboard=unnamedplus
endif
"}}}
"{{{ Create Directories
if has("persistent_undo")
  call CreateDirectoryIfMissing($HOME."/.vim/undodir")
  set undodir=$HOME/.vim/undodir//
  set undofile
endif

call CreateDirectoryIfMissing($HOME."/.vim/swapfiles")
call CreateDirectoryIfMissing($HOME."/.vim/backups")
set directory=$HOME/.vim/swapfiles//
set backupdir=$HOME/.vim/backups//
"}}}
"{{{ OS Settings
" At least the ones that don't belong anywhere else

if g:os == "FreeBSD"
  " Different to support older/less compatible terminals.
  colorscheme eldar
  call coc#config("rust-analyzer.updates.prompt", "neverDownload")
else
  set termguicolors
  " colorscheme gruvbox
endif

if g:os == "Linux" && !has('nvim')
  if empty($FORCE_BG)
    set background=dark
    " Make most backgrounds transparent
    call RemoveBG("BufTabLineActive")
    hi BufTabLineCurrent guibg=NONE ctermbg=NONE guifg=#c8b9a4 ctermfg=white
    hi BufTabLineHidden guibg=NONE ctermbg=NONE guifg=#555555
    call RemoveBG("BufTabLineFill")
    call RemoveBG("CursorLineNR")
    call RemoveBG("Folded")
    call RemoveBG("Normal")
    call RemoveBG("VertSplit")
    hi Normal guifg=white ctermfg=white
    call RemoveBG("StatusLine")
    hi CocHighlightText ctermfg=cyan guifg=cyan
    if has('nvim')
      unlet g:terminal_color_0
      unlet g:terminal_color_1
      unlet g:terminal_color_2
      unlet g:terminal_color_3
      let g:terminal_color_4 = "#00aaff"
      unlet g:terminal_color_5
      unlet g:terminal_color_6
      unlet g:terminal_color_7
      unlet g:terminal_color_8
      unlet g:terminal_color_9
      unlet g:terminal_color_10
      unlet g:terminal_color_11
      unlet g:terminal_color_12
      unlet g:terminal_color_13
      unlet g:terminal_color_14
      unlet g:terminal_color_15
    endif
  endif
endif
"}}}
