"---------------------------------------------------------
" Features {{{
" These lines must be called before enabling filetype detection
" {TODO} vimcast.org - Syncronizing plugins with git submodels and pathogen -
" don't need pathogen, but need to keep plugins sync'd. Use minpac?

filetype indent plugin on
filetype plugin on " to support filetype plugins like todo.txt-vim

syntax on

" {TODO} Fix the colorscheme
" {TODO} Change the font to Fire Code Retina & select a larger font
" {TODO} Install plugins (matchit, todo.txt-vim, surround...  Most downloaded
" to Windows already)
let g:solarized_termcolors=256
set t_Co=256
set background=dark
silent! colorscheme solarized8

" Fira Code
set guifont=Fira_Code_Retina:h11:cANSI:qDRAFT
set renderoptions=type:directx " Enable Ligatures in Fira Code for Vim; https://github.com/tonsky/FiraCode/issues/462
set encoding=utf-8


autocmd BufRead,BufNewFile *.dat.* set filetype=dat

" {TODO} Activate next line in Windows (Linux command doesn't work)
" source /usr/share/vim/vim74/macros/matchit.vim
" source /usr/share/vim/vim74/macros/ INSTALL ADDITIONAL PLUGINS
" To get:  surround.vim plugin (Practical Vim pg. 129)
" Wraps a selection with a pair of delimiters


"---------------------------------------------------------
" Must have options {{{

set hidden " allow buffer switching without saving (enables ctags & quickfix commands :cdo)

set wildmenu " vim provides a navigable list of autocomplete suggestions. Navigate with <Tab>, ^n or <S-Tab>, ^p (Practival Vim p66)

set showcmd

set hlsearch

set number " turn on line numbering
"---------------------------------------------------------
" Usability options {{{

set ignorecase " makes search case insensitive (side effect: autocomplete also case insensitive)
set smartcase " overridds the 'ignorecase' option if the search pattern contains upper case characters
set infercase " makes autocomplete case sensitive (Practical Vim pg. 276)

set wildchar=<Tab> wildmenu wildmode=longest,list "pressing Tab on the command line will show a menu to complete buffer & file names (http://vim.wikia.com/wiki/Easier_buffer_switching & Practical Vim p66)

set backspace=indent,eol,start

set autoindent

set nostartofline

set ruler   "displays the current line and column

set laststatus=2 statusline=%02n:%<%f\ %h%m%r=%-14.(%l,%c%V%)\ %P  " show the buffer number in the status line (http://vim.wikia.com/wiki/Easier_buffer_switching)

set confirm

set visualbell

set t_vb=

set mouse=a

set cmdheight=2

set notimeout ttimeout ttimeoutlen=200

set pastetoggle=<F11>

set history=200 "Practical Vim p. 68

set nrformats=  "treat all #'s as decimals, regardless of whether they are padded with zeros (Practical Vim p. 21)
" makes Vim's <C-a> <C-x> commands behave as expected and not do octal math

"---------------------------------------------------------
" Turn on hybrid line numbering (github: jeffkreeftmeijer/vim-numbertoggle)
" Automatic toggling between 'hybrid' and absolute line numbers
augroup numbertoggle
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu | set relativenumber   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu | set norelativenumber | endif
augroup END

"---------------------------------------------------------
" Indentation options {{{

set tabstop=3
set shiftwidth=3
set softtabstop=3
set expandtab

"---------------------------------------------------------
" Folding Options {{{

set fdm=syntax
set fdc=4

"---------------------------------------------------------
" Mappings {{{

" Map Caps Lock to Control for easier finger access (i.e. ESC via <C-[> and all other CTRL commands: <C-f>, <C-b>, <C-e>, <C-h>, <C-l>, <C-y>)
" Key Remapping done in NoMachine via: System-Preferences-Keyboard-Layout
map <CAPS> <CTRL>

" map ESC to Ctrl-a (convenient with Dvorak layout & CAPS remapped) - Doug
" Black "A Good Vimrc"
" Ctrl-a Ctrl-s are both ways to get to Normal mode (convenient in Dvorak layout)
" {TODO} It looks like Ctrl-c is already mapped to esc by default.  Don't
" understand the warning message
inoremap <C-a> <esc>

" Make Y behave like similar commands and yank to end of line
map Y y$

" Remove highlighting after a search with CRTL-L, normal mode
nnoremap <C-L> :nohl<CR><C-L>

" Select text between quotation marks & search for selection
nnoremap v" vi":<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>

" Display ctags tag list for item between quotation marks
nmap g" vi"g<C-]>

" Use CTRL-S to save the file while in insert mode & switch to normal mode
" (Like RStudio vim bindings. Great timesaver.)
silent !stty -ixon
inoremap <C-S> <ESC>:w<CR>
" inoremap <C-S> <ESC>:w<CR>a
autocmd VimLeave * silent !stty ixon

" Repeat last substitution WITH all previous flags in normal & visual mode -
" autopopulates the range ('<,'>) - (Practical Vim p227)
nnoremap & :&&<CR>
xnoremap & :&&<CR>

" Toggle fold with Backspace key (Greg Hurrell uses <S-Tab>)
" https://www.youtube.com/watch?v=oqYQ7IeDs0E&t=2s
nmap <BS> za

" Enter Ex mode with space key
noremap <Space> :

" Easy expansion of the Active File Directory (Practival Vim pg. 95)
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
"Now when we type %% on Vimâ€™s : command-line prompt, it automatically expands to the path of the active buffer, just as though we had typed %:h <Tab> . 
"Besides working nicely with :edit, this can come in handy with other Ex commands such as :write, :saveas, and :read.
"Vimcasts episode on the :edit command (http://vimcasts.org/episodes/the-edit-command/)

" Automatically center search/jumps on screen (stackoverflow question 1480043)
nnoremap <Leader>n nzz
nnoremap <Leader>N Nzz
nnoremap <C-o> <C-o>zz
nnoremap <C-i> <C-i>zz

" Search for the current visual selection (Practical VIM pg. 213)
" makes * and # work in visual mode too.  (updated code on github:
" nelstrom/vim-visual-star-search)
function! s:VSetSearch(cmdtype)
    let temp = @s
    norm! gv"sy
    let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
    let @s = temp
endfunction

xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" Count number of matches of a pattern in a file (Uses last visual-star-search)
nnoremap <leader>* :%s///gn<CR>
" Count the number of matches in the project 
" nnoremap <leader>\gn :%s///gn `cat files`<CR>

" Populate the quickfix list for a STORM project using backtick expansion of paths.dat for the last visual star search
" (backtick exlansion in cshell. use $(cat files) in BASH)
" The quickfix list is available globally, but you can only have one at any
" given moment
" Revert to older lists with :colder and :cnewer commands
nnoremap <silent> <leader>** :vim //g `cat files`<CR>:copen<CR>
" The location list is bound to a window. You can have different lists in each
" window simultaneously.
nnoremap <silent> <leader>l* :lvim //g `cat files`<CR>:lopen<CR>

"if maparg('<leader>*', 'n') == ''
"    nmap <leader>* :execute 'noautocmd !pathsgrep -n /\V' . substitute(escape(expand("<cword>"), '\'), '\n', '\\n', 'g') . '/ *'<CR>
"endif
"if maparg('<leader>*', 'v') ==''
"    vmap <leader>* :<C-u>call <SID>VSetSearch()<CR>:execute 'noautocmd !pathsgrep -n /' . @/ . '/ *'<CR>
"endif

" recursively vimgrep for word under cursor or selection if you hit
" leader-star (populate the quickfix list)
"if maparg('<leader>*', 'n') == ''
"    nmap <leader>* :execute 'noautocmd vimgrep /\V' . substitute(escape(expand("<cword>"), '\'), '\n', '\\n', 'g') . '/ **'<CR>
"endif
"if maparg('<leader>*', 'v') ==''
"    vmap <leader>* :<C-u>call <SID>VSetSearch()<CR>:execute 'noautocmd vimgrep /' . @/ . '/ **'<CR>
"endif

" Use F10 to trace syntax highlighting, great for debuging custom syntax
map <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
"---------------------------------------------------------

" Mappings to quickly traverse Vim's lists (Practical Vim pg. 79)
" Buffer List, Argument List, Location List, Tag List, Quickfix List
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
" Argument List
nnoremap <silent> [a :previous<CR>
nnoremap <silent> ]a :next<CR>
nnoremap <silent> [A :first<CR>
nnoremap <silent> ]A :last<CR>
" Location List
nnoremap <silent> [l :lprevious<CR>
nnoremap <silent> ]l :lnext<CR>
nnoremap <silent> [L :lfirst<CR>
nnoremap <silent> ]L :llast<CR>
" Tag List
nnoremap <silent> [t :tprevious<CR>
nnoremap <silent> ]t :tnext<CR>
nnoremap <silent> ]T :tnext<CR>
nnoremap <silent> [T :tfirst<CR>
" Quickfix List (use [q not [c so that vimdiff commands work)
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [Q :cfirst<CR>
nnoremap <silent> ]Q :clast<CR>

" Move up/down through filtered command history (Practical Vim p. 69)
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>

" Jump by soction or to the next { in the first column.
" From :h ]]  If your '{' or '}' are not in the first column, use mappings
" below to use "[["
map [[ ?{<CR>w99[{
map ][ /}<CR>b99]}
map ]] j0[[%/{<CR>
map [] k$][%?}<CR>

" Populate the quickfix list with fatal errors from run_messages.error.prolog " (Storm 2.6) or run_messages.out.error.1.1 (Storm 2.7) " nnoremap <leader>q :cexpr system('grep ^\/apps1 run_messages.error.prolog')<CR> (Storm 2.6)
nnoremap <leader>q :cexpr system('grep ^\/apps1 run_messages.out.error.1.1')<CR>:copen<CR> "(Storm 2.7)

" Populate quickfix with pathsgrep (No need to change the grepformat settings (:set
" grepformat=%f:%l:%m,%f:%l%m,%f  %l%m).  Pathsgrep parses in a format Vim understands
set grepprg=pathsgrep\ $*

" Ref:  superuser.com - Reload vimrc in vim without restart
" Mapping to open .vimrc from any buffer with leader vimrc (Default leader \)
map <leader>vimrc :tabe $MYVIMRC<cr>
" Mapping to open .bashrc from any buffer with leader bashrc (Default leader \)
map <leader>bashrc :tabe ~/.bashrc<cr>
" Mapping to open .aliasrc from any buffer with leader aliasrc (Default leader \)
map <leader>aliasrc :tabe ~/.aliasrc<cr>
" Automatically source changes to the .vimrc when you save the file
autocmd bufwritepost ~/.vimrc source $MYVIMRC
" Mapping to open .viminfo file (:h viminfo-file-name starting.txt)
map <leader>viminfo :tabe $HOME/.viminfo<cr>

" Toggle invisibles shortcut (VimCast #1 Show invisibles)
nnoremap <leader>ll :set list!<CR>
" Use the same symbols as TextMate for tabstops and EOLs
set listchars=tab:^\ ,eol:¬ " ctrl-v u00ac inserts '¬' (the not sign). There are no tabstops with expandtab set.
" Invisible character colors to blend with background
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

" Yank all matches of regex group into register a
noremap <leader>y qaq<CR>:%s//\=setreg('A', submatch(0))/n<CR>

" build a gvimdiff shell command to execute via :w !sh
vnoremap <leader>s :!awk '{print "gvimdiff "$0" PATH/"$0""}'<CR>gv :s/PATH/..\//

" Activate dictionary with :set spell enabled {New}
inoremap <leader>x <C-x><C-k><C-p>

" todo.txt-vim
let g:Todo_fold_char='+'
map <leader>todo :tabe C:\Users\ryanl\Dropbox\Apps\todo\todo.txt<CR>
" Unused keys in normal mode: - H L <space> <BS> <CR> <TAB> (Learn Vimscript
" the Hard Way)
let mapleader = "-"
let maplocalleader = "-"
" Use todo#Complete as the omni complete function for todo files
au filetype todo setlocal omnifunc=todo#Complete
" Auto complete projects
au filetype todo imap <buffer> + +<C-X><C-O>
" Auto complete contexts
au filetype todo imap <buffer> @ @<C-X><C-O>
" Open fold with Ctrl Tab - {TODO} find Greg Hurell video
nmap <c-tab> za

" Mappings
" Window Switching
nnoremap <C-k> <C-w>k
nnoremap <C-j> <C-w>j
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <C-k> <C-w>k
