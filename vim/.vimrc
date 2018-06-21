" ~/.vimrc
"
" Need to compile vim with python support (editors/vim with CONSOLE mode
" selected)
"
" install dash, libclang (included with llvm past 40), llvm50 (or higher),
" boost-all, boost-python-libs, fzf
"
" Be sure to set clang-format for Glaive for formatting
"
"
" npm install -g typescript, js-beautify
"
" install yapf for python
"
" Plug commands: PlugInstall, PlugUpdate, PlugClean, PlugUpgrade (vim-plug
" itself)
" Set g:plug_timeout to large value if necessary

" --- REMINDER --- Also need to set Glaive
let $LD_LIBRARY_PATH .= ':/usr/local/llvm50/lib/'

let mapleader = " "

"{{{ Key Bindings
" :rrc -> reload vimrc
" , fold
" <F4> NerdTreeToggle
" <F5> UndoTreeToggle
" :Nnum and :Num hides/shows numbers

" Eunuch
" :SudoWrite
" :SudoEdit
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
" :P or <leader>p to just search for files
" :H to <leader>h search home for files
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

let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_fields = 1
let g:go_highlight_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_fmt_command = "goimports"
Plug 'fatih/vim-go'
"}}}
"{{{ Autocompletion
Plug 'tomtom/tcomment_vim'
Plug 'tpope/vim-surround'

"{{{ YouCompleteMe Settings
" Disable preview entirely
set completeopt-=preview
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

function! BuildYCM(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a.info.status == 'updated' || a:info.force
    !./install.py --clang-completer --go-completer --js-completer
  endif
endfunction
"}}}

Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
"}}}
"{{{ Navigation / Searching
"{{{ FZF Searching
let g:rgf_command = '
  \ rg --column --line-number --no-heading --fixed-strings --smart-case --no-ignore --hidden --follow --color "always" --max-count 10
  \ -g "*.{js,json,php,md,styl,jade,html,config,py,cpp,c,go,hs,rb,conf,ts,dart,toml,scss,css,sass,yaml}"
  \ -g "!**/{.git,node_modules,vendor,dist,.sass-cache,.vim}/*" '

" Ripgrep in --files mode is still faster than find
let g:rgs_command = '
  \ rg --files --no-ignore --column --no-heading --hidden --follow  --color "always"
  \ -g "!**/{.git,node_modules,vendor,.sass-cache,.vim}/*" | awk ''{print $1":1:1"}'''

" Steal the default command from FZF's environment variables
" TODO -- It'd be nice to get rid of awk here
if !empty($FZF_DEFAULT_COMMAND)
  let g:rgs_command = $FZF_DEFAULT_COMMAND . ' | awk ''{print $1":1:1"}'''
endif
if !empty($FZF_CTRL_T_COMMAND)
  let g:rgs_command = $FZF_CTRL_T_COMMAND . ' | awk ''{print $1":1:1"}'''
endif

command! -bang -nargs=* S call GrepDir(ProjectRoot(), g:rgf_command .shellescape(<q-args>), 1, <bang>0)
command! -bang -nargs=* P call GrepDir(ProjectRoot(), g:rgs_command, 0, <bang>0)
command! -bang -nargs=* H call GrepDir('~', g:rgs_command, 0, <bang>0)
call SetupCommandAlias("M", "Buffers")
nnoremap <leader>h :H<cr>
nnoremap <leader>p :P<cr>
nnoremap <leader>m :Buffers<cr>
nnoremap <leader>s :call PromptInput(":S")<cr>
"}}}
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

nnoremap <F4> :NERDTreeToggle<cr>
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
"}}}
"{{{ Copying and Pasting
let g:highlightedyank_highlight_duration = 2000
Plug 'machakann/vim-highlightedyank'
Plug 'roxma/vim-tmux-clipboard'
Plug 'ConradIrwin/vim-bracketed-paste'
"}}}
"{{{ Tmux
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'christoomey/vim-tmux-navigator'
"}}}
"{{{ Code Formatting

augroup autoformat_settings
  autocmd!
  " autocmd FileType bzl AutoFormatBuffer buildifier
  autocmd FileType c,cpp,proto,javascript,typescript AutoFormatBuffer clang-format
  " autocmd FileType dart AutoFormatBuffer dartfmt
  " autocmd FileType gn AutoFormatBuffer gn
  autocmd FileType html,css,json AutoFormatBuffer js-beautify
  " autocmd FileType java AutoFormatBuffer google-java-format
  autocmd FileType python AutoFormatBuffer yapf
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
augroup END

Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'
"}}}

nnoremap <F5> :UndotreeToggle<cr>
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-vividchalk'
call plug#end()
"}}}

call glaive#Install()
Glaive codefmt plugin[mappings]
Glaive codefmt clang_format_executable="clang-format50"

"{{{ Filetype Settings
function! s:CompleteTags()
  inoremap <buffer> >< ></<C-x><C-o><Esc>:startinsert!<CR><C-O>?</<CR>
  inoremap <buffer> ><CR> ></<C-x><C-o><Esc>:startinsert!<CR><C-O>?</<CR><CR><Tab><CR><Up><C-O>$
  inoremap <buffer> </ </<C-x><C-o><Esc>:startinsert!<CR><C-O>?</<CR>
endfunction

augroup filetype_settings
  autocmd!
  autocmd FileType go setlocal noexpandtab nosmarttab tabstop=2
  autocmd BufRead,BufNewFile *.html,*.js,*.ts,*.xml call s:CompleteTags()
  autocmd FileType vim setlocal foldmethod=marker foldlevel=0
augroup END
"}}}
"{{{ Custom Commands and Keybinds
command! Nnum set nonumber | set norelativenumber
command! Num set number | set relativenumber
call SetupCommandAlias("rrc", "so ~/.vimrc")
call SetupCommandAlias("W", "w")
nnoremap <Leader>v :ls<CR>:b<Space>
nnoremap <leader>c <C-w>c
nnoremap , za
"}}}
"{{{ Settings
colorscheme vividchalk
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
"set notimeout
" Handle escape character timeouts
set timeout
set timeoutlen=100000 ttimeoutlen=10

if executable('dash')
  set shell=dash
elseif executable('bash')
  set shell=bash
endif
"}}}
"{{{ Create Directories
if has("persistent_undo")
  call CreateDirectoryIfMissing('$HOME/.vim/undodir')
  set undodir=$HOME/.vim/undodir//
  set undofile
endif

call CreateDirectoryIfMissing('$HOME/.vim/swapfiles')
call CreateDirectoryIfMissing('$HOME/.vim/backups')
set directory=$HOME/.vim/swapfiles//
set backupdir=$HOME/.vim/backups//
"}}}
