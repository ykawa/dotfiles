set background=dark
colorscheme koehler

set mouse-=a

set ambiwidth=double
set fenc=utf-8
set nobackup
set noswapfile
set autoread
set hidden
set showcmd

set nostartofline
set showmatch matchtime=1
set nowritebackup

set number
set virtualedit+=block
set smartindent
set autoindent
set noerrorbells
set laststatus=2
set display=lastline
set cmdheight=2
set wildmode=list:longest

set list
set listchars=tab:\▸\ ,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=2

set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
set shellslash

set encoding=utf-8
set fileformats=unix,dos,mac
syntax enable

filetype plugin indent on

nnoremap j gj
nnoremap k gk
nnoremap <S-l> $
nnoremap <S-h> ^
nnoremap == gg=G''
"nnoremap <Esc><Esc> :nohlsearch<CR><ESC>
nmap <Esc><Esc> :nohlsearch<CR><Esc>

