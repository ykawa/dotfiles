" 全設定をデフォルト値に設定する
set all&
autocmd!
" tiny と small はここで終了する
"if !1 | finish | endif

set nocompatible
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

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

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

set relativenumber
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
nnoremap <silent><C-l><C-l> :<C-u>set nohlsearch!<CR><Esc>

let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python'

if dein#check_install()
  call dein#install()
endif

" helpやQuickFixを 'q' で閉じる
autocmd FileType help,qf,vim,twitvim,denite nnoremap <silent><buffer>q <C-w>c

" " QuickFix自動で閉じる
" augroup QfAutoCommands
"   autocmd!
"   " Auto-close quickfix window
"   autocmd WinEnter * if (winnr('$') == 1) && (getbufvar(winbufnr(0), '&buftype')) == 'quickfix' | quit | endif
" augroup END

" vimでtwitter
let twitvim_enable_python = 1
let twitvim_browser_cmd = 'google-chrome'
let twitvim_force_ssl = 1
let twitvim_count = 40
nmap [twitvim] <Nop>
map <S-t> [twitvim]
nnoremap [twitvim]T :<C-u>PosttoTwitter<CR>
nnoremap [twitvim]F :<C-u>FriendsTwitter<CR><C-w><C-w>
nnoremap [twitvim]U :<C-u>UserTwitter<CR><C-w><C-w>
nnoremap [twitvim]R :<C-u>MentionsTwitter<CR><C-w><C-w>
nnoremap [twitvim]D :<C-u>DMTwitter<CR>
nnoremap [twitvim]S :<C-u>DMSentTwitter<CR>
nnoremap [twitvim]N :<C-u>NextTwitter<CR>
nnoremap [twitvim]P :<C-u>PreviousTwitter<CR>
nnoremap [twitvim]<Leader> :<C-u>RefreshTwitter<CR>

nnoremap <silent> ++ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> -- :exe "resize " . (winheight(0) * 2/3)<CR>

nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q  <Nop>

nnoremap <silent><C-F5> :tabprev<CR>
nnoremap <silent><C-F6> :tabnext<CR>


filetype plugin indent on
syntax enable

