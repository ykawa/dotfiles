set encoding=utf-8
scriptencoding utf-8

filetype off

" dein.vim
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if &runtimepath !~# '/dein.vim'
  if !isdirectory(s:dein_repo_dir)
    execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
  endif
  execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)

  let g:rc_dir    = expand('~/dotfiles')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif

set mouse-=a
set ambiwidth=double
set nobackup
set noswapfile
set autoread
set hidden
set showcmd

set nostartofline
set showmatch matchtime=1
set nowritebackup

set number
set nowrap
set virtualedit+=block
set autoindent
set noerrorbells
set belloff=all
set laststatus=2
set display=lastline
set cmdheight=2
set wildmode=list:full

set list
set listchars=tab:\¦\ ,trail:-,eol:↲,extends:»,precedes:«,nbsp:%
" インデントをshiftwidthの倍数に丸める
set shiftround
set smartindent
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

set scrolloff=20
set fileencoding=utf-8
set fileformats=unix,dos,mac

set completeopt=longest,menu,menuone

"" 補完の際の大文字小文字の区別しない
set infercase
" 新しく開く代わりにすでに開いてあるバッファを開く
set switchbuf=useopen

" 入力モード中に素早くjjと入力した場合はESCとみなす
inoremap jj <Esc>
" vを二回で行末まで選択
vnoremap v $h

nnoremap j gj
nnoremap k gk
nnoremap <S-l> $
nnoremap <S-h> ^
nnoremap == gg=G''
nnoremap n nzz
nnoremap N Nzz
nmap <C-l> <C-l>:nohlsearch<CR><Esc>

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

"set tags+=.git/tags,.svn/tags,tags

colorscheme elflord
set background=light
set background=dark
"highlight Pmenu ctermfg=15 ctermbg=242 gui=underline guibg=DarkGrey
highlight Pmenu ctermbg=31 guibg=Cyan
highlight PmenuSel term=bold ctermfg=0 ctermbg=36 guibg=Magenta

" helpやquickfixを 'q' で閉じる
autocmd FileType help,qf nnoremap <silent><buffer>q <C-w>c

