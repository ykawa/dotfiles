set nocompatible

set background=dark
colorscheme koehler

set ambiwidth=double
set fenc=utf-8
set nobackup
set noswapfile
set autoread
set hidden
set showcmd

set nostartofline
set showmatch

set number
set cursorline
"set cursorcolumn
set virtualedit+=block
set smartindent
set autoindent
"set visualbell
set laststatus=2
set wildmode=list:longest
nnoremap j gj
nnoremap k gk

" set list listchars=tab:\▸\-
set list
set listchars=tab:\▸\ ,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
set expandtab
set tabstop=2
set shiftwidth=2

set ignorecase
set smartcase
set incsearch
set wrapscan
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>

set encoding=utf-8
set fileformats=unix,dos,mac
syntax enable

filetype plugin indent on

