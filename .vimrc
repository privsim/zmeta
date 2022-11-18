" General Settings: {{{
set clipboard+=unnamed
set nocompatible
set encoding=utf-8
set nobackup                    " We have vcs, we don't need backups this way
set nowritebackup               " We have vcs, we don't need backups this way
set noswapfile                  " No need for this on a modern system
set hidden                      " allow me to have buffers with unsaved changes.
set autoread                    " when a file has changed on disk, just load it. Don't ask.
set autowrite                   " autosaving files is a nice feature
set lazyredraw                  " don't redraw the screen on macros, or other non-typed operations
set shortmess+=I                " no vim welcome screen
set virtualedit+=block          " allow the cursor to go anywhere in visual block mode
set backspace=indent,eol,start  " define what backspace does
set wildmenu
set wildmode=list:full
set foldmethod=marker

" https://vim.fandom.com/wiki/Disable_beeping
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" }}}

" Cursor: {{{
" Use a line cursor within insert mode and a block cursor everywhere else.
" Reference chart of values:
"   Ps = 0  -> blinking block.
"   Ps = 1  -> blinking block (default).
"   Ps = 2  -> steady block.
"   Ps = 3  -> blinking underline.
"   Ps = 4  -> steady underline.
"   Ps = 5  -> blinking bar (xterm).
"   Ps = 6  -> steady bar (xterm).
let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
" }}}

" Editor: {{{

" to get the postscript name, use ⌘-i in fontbook
if has('gui_running')
    set guifont=InconsolataNerdFontMono-Regular:h13
endif
set list                            " needed for listchars
set listchars=tab:»\ ,trail:·       " Display tabs and trailing spaces visually
set number                          " Enable line numbers
set mouse=a                         " Enable mouse integration
set title                           " Sets the terminal to show the buffer title
set showcmd                         " show commands as I type thiem
set scrolloff=4                     " when scrolling around, keep a buffer of a few lines above/below

" }}}

" Whitespace: {{{

set expandtab                       " use spaces instead of tabs.
set tabstop=4                       " number of spaces that a tab in a file counts for
set shiftwidth=4                    " affects how autoindentation works
set softtabstop=4                   " when tab is pressed, only move to the next tab stop
set shiftround                      " tab / shifting moves to closest tabstop.
set autoindent                      " match indents on new lines.
set smartindent                     " intelligently  dedent / indent new lines based on rules.

" }}}

"
" Key bindings
"

" space makes a nice leader key
nnoremap <SPACE> <Nop>
let mapleader = " "
nnoremap <Leader>ve :e $MYVIMRC<CR>
nnoremap <Leader>vr :source $MYVIMRC<CR>

" Make U be redo.
nnoremap U <C-r>

""" CUA shortcuts
" meta(alt)-left/right moves across words
map <M-Left>  B
map <M-Right> W
map <M-Up>    {
map <M-Down>  }

" Make search more sane
set ignorecase " case insensitive search
set smartcase  " If there are uppercase letters, become case-sensitive.
set incsearch  " live incremental searching
set showmatch  " live match highlighting
set hlsearch   " highlight matches
set gdefault   " use the `g` flag by default.
" make search use normal PERL regex
" nnoremap / /\v
" vnoremap / /\v
" This unsets the "last search pattern" register by hitting return
nnoremap <CR> :noh<CR><CR>:<backspace>

" Save on focus lost (breaks when unnamed)
" au FocusLost * :wa

" Theme: {{{
" to get the postscript name, use ⌘-i in fontbook
set background=dark   " tell nvim the color scheme will be a dark one
if has('gui_running')
    set guifont=MesloLGSNerdFontComplete-Regular:h13
    colorscheme evening   " set the color scheme (builtin: evening, elflord, delek)
else
    colorscheme pablo
endif
syntax on
highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE
" }}}

" FZF: {{{
set rtp+=/usr/local/opt/fzf
" }}}



if has('persistent_undo') && isdirectory(expand('~').'/.vim/backups')
  silent !mkdir ~/.vim/backups > /dev/null 2>&1
  set undodir=~/.vim/backups
  set undofile
endif


#" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>
" ================ Completion =======================

set wildmode=list:longest
set wildmenu                "enable ctrl-n and ctrl-p to scroll thru matches
set wildignore=*.o,*.obj,*~ "stuff to ignore when tab completing
set wildignore+=*vim/backups*
set wildignore+=*sass-cache*
set wildignore+=*DS_Store*
set wildignore+=vendor/rails/**
set wildignore+=vendor/cache/**
set wildignore+=*.gem
set wildignore+=log/**
set wildignore+=tmp/**
set wildignore+=*.png,*.jpg,*.gif

" ================ Scrolling ========================

set scrolloff=8         "Start scrolling when we're 8 lines away from margins
set sidescrolloff=15
set sidescroll=1

" ================ Search ===========================

set incsearch       " Find the next match as we type the search
set hlsearch        " Highlight searches by default
set ignorecase      " Ignore case when searching...
set smartcase       " ...unless we type a capital

" ================ Security ==========================
set modelines=0
set nomodeline

" ================ Aditional =========================

set omnifunc=syntaxcomplete#Complete

set listchars=tab:\|\ ,trail:.

" Speed up response to ESC key
set notimeout
set ttimeout
set timeoutlen=100

set statusline=[TYPE=%Y]\ [ENC=%{&fenc}]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]
hi StatusLine term=bold,reverse cterm=bold ctermfg=7 ctermbg=0
hi StatusLineNC term=reverse cterm=bold ctermfg=8

set t_Co=256
"colorscheme darkblue
set encoding=utf-8   
set mouse=a  
set lazyredraw
