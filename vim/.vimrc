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
" npm install -g typescript js-beautify
"
" install yapf for python
"
" Plug commands: PlugInstall, PlugUpdate, PlugClean, PlugUpgrade (vim-plug
" itself)
" Set g:plug_timeout to large value if necessary

" --- REMINDER --- Also need to set Glaive
let g:os = substitute(system('uname'), '\n', '', '')
if g:os == "FreeBSD"
  let $LD_LIBRARY_PATH .= ':/usr/local/llvm60/lib/'
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
Plug 'leafgarland/typescript-vim'
Plug 'othree/yajs.vim'
Plug 'othree/es.next.syntax.vim'
let g:python_highlight_all = 1
Plug 'vim-python/python-syntax'
Plug 'tmhedberg/SimpylFold'
let g:yapf_style = "google"
Plug 'google/yapf', { 'rtp': 'plugins/vim', 'for': 'python' }
" Plug 'rust-lang/rust.vim'

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
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
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
Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
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
nnoremap <C-q> :call GrepDir($HOME, g:rgs_command, 0, 0)<cr>
nnoremap <C-s> :call GrepDir($SOURCE_DIR, g:rgs_command, 0, 0)<cr>
nnoremap <C-d> :call GrepDir($NASHOME, g:rgs_command, 0, 0)<cr>
nnoremap <leader>m :Buffers<cr>
nnoremap <leader>s :call PromptInput(":S")<cr>
"}}}
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-sneak'

nnoremap <F4> :NERDTreeToggle<cr>
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
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
  return expand('%:p') !~# '\V'.$THIRD_PARTY_SOURCE
endfun

augroup autoformat_settings
  autocmd!
  " autocmd FileType bzl if s:ShouldFormat() | exe 'AutoFormatBuffer buildifier' | endif
  autocmd FileType c,cpp,proto,javascript,typescript if s:ShouldFormat() | exe 'AutoFormatBuffer clang-format' | endif
  " autocmd FileType dart if s:ShouldFormat() | exe 'AutoFormatBuffer dartfmt' | endif
  " autocmd FileType gn if s:ShouldFormat() | exe 'AutoFormatBuffer gn' | endif
  autocmd FileType go if s:ShouldFormat() | exe 'AutoFormatBuffer gofmt' | endif
  autocmd FileType html,css,json if s:ShouldFormat() | exe 'AutoFormatBuffer js-beautify' | endif
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
Plug 'roxma/vim-tmux-clipboard'
" This needs to be loaded after vim-tmux-focus-events
Plug 'ConradIrwin/vim-bracketed-paste'
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
Plug 'morhetz/gruvbox'

"Plug 'tpope/vim-vividchalk'
call plug#end()
"{{{ YouCompleteMe Settings
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

"}}}
"}}}

call glaive#Install()
Glaive codefmt plugin[mappings]
if g:os == "FreeBSD"
  Glaive codefmt clang_format_executable="clang-format60"
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
  autocmd FileType python setlocal softtabstop=4 shiftwidth=4
  autocmd FileType go setlocal noexpandtab nosmarttab tabstop=2
  autocmd FileType go nnoremap <buffer> <Leader>l :GoLint<cr>
  autocmd BufRead,BufNewFile *.html,*.js,*.ts,*.xml call s:CompleteTags()
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

set termguicolors
set background=dark
colorscheme gruvbox
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
set foldmethod=syntax
set foldlevelstart=20
set backspace=indent,eol,start
set modeline
set smartcase
set encoding=utf8
set fillchars+=vert:│
set fillchars+=fold:─
set fileencodings=ucs-bom,utf-8,sjis

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
  " Highlight once past 80 characters. Works out well for two files side-by-side.
  autocmd BufWinEnter * call matchadd('ColorColumn', '\%>79v.')
  autocmd BufWinEnter * highlight ExtraWhitespace ctermbg=red guibg=red
  "autocmd BufWinEnter * call matchadd('ExtraWhitespace', '\s\+$', 11)
  autocmd BufWinEnter * call matchadd('ExtraWhitespace', '\s\+\%#\@<!$')
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
if g:os == "Linux"
  if empty($FORCE_BG)
    " Make most backgrounds transparent
    call RemoveBG("BufTabLineActive")
    hi BufTabLineCurrent guibg=NONE ctermbg=NONE guifg=#c8b9a4 ctermfg=white
    call RemoveBG("BufTabLineFill")
    hi BufTabLineHidden guibg=NONE ctermbg=NONE guifg=#555555
    call RemoveBG("CursorLineNR")
    call RemoveBG("Folded")
    call RemoveBG("Normal")
    call RemoveBG("VertSplit")
    hi Normal guifg=white ctermfg=white
  endif
endif
"}}}
