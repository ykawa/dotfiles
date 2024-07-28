" 全設定をデフォルト値に設定する
set all&
autocmd!

" tiny と small はここで終了する

if !1 | finish | endif

" Ruby設定（動的にrbenvのRubyパスを設定）
let g:ruby_host_prog = substitute(system('rbenv which ruby'), '\n', '', '')

" Perl設定（動的にplenvのPerlパスを設定）
let g:perl_host_prog = substitute(system('plenv which perl'), '\n', '', '')

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Run PlugInstall if there are missing plugins
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/plugged')
  Plug 'dracula/vim', { 'as': 'dracula' }

  Plug 'andymass/vim-matchup'

  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  Plug 'airblade/vim-gitgutter'

  Plug 'itchyny/lightline.vim'

  Plug 'Yggdroot/indentLine'
  let g:indentLine_conceallevel = 0
call plug#end()

set nocompatible
set encoding=utf-8
scriptencoding utf-8
set fileencodings=utf-8,euc-jp,cp932

" coc.nvimで自動でインストールされる拡張機能
let g:coc_global_extensions = [
      \ 'coc-json',
      \ 'coc-tsserver',
      \ 'coc-python',
      \ 'coc-html',
      \ 'coc-css',
      \ 'coc-solargraph'
      \ ]

" lightline.vimの設定
let g:lightline = {
      \ 'colorscheme': 'dracula',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
    \ }

" vim-gitgutterの設定
let g:gitgutter_highlight_lines = 0
let g:gitgutter_enabled = 1
let g:gitgutter_map_keys = 0  " デフォルトのキーマッピングを無効化
function! GitStatus()
  let [a,m,r] = GitGutterGetHunkSummary()
  return printf('+%d ~%d -%d', a, m, r)
endfunction
if exists('GitGutterGetHunkSummary')
  set statusline+=%{GitStatus()}
endif

" キーバインド設定
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" 自動補完の設定
inoremap <silent><expr> <C-Space> coc#refresh()

filetype off

set statusline+=%#warningmsg#
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

set nolist
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

set completeopt=menuone,noinsert,noselect
set shortmess+=c

set wildmenu
set wildmode=longest:list,full
set complete=.,w,b,u,t,i

" 補完の際の大文字小文字の区別しない
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

" CTRL+l ２回で検索の強調表示を消す
nnoremap <silent><C-l><C-l> :<C-u>set nohlsearch!<CR><Esc>

let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python'
let g:powerline_pycmd = 'py3'

" helpやQuickFixを 'q' で閉じる
nnoremap q <Nop>
autocmd FileType help,qf,vim,twitvim,denite,quickrun nnoremap <silent><buffer>q <C-w>c

" ++ と -- でバッファのウインドウサイズを変更する
nnoremap <silent> ++ :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> -- :exe "resize " . (winheight(0) * 2/3)<CR>

" 不要なキーを削除する
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Q  <Nop>

" CTRL-F5 と CTRL-F6 で複数ファイルのタブ移動する
nnoremap <silent><C-F5> :tabprev<CR>
nnoremap <silent><C-F6> :tabnext<CR>

" .vimrc 再読込設定 & 編集時はReload
nnoremap <Leader>r :source $MYVIMRC<CR>
autocmd BufWritePost .vimrc source $MYVIMRC

" 個別設定
" Makefile
let _curfile=expand("%:r")
if _curfile == 'Makefile'
  setlocal noexpandtab
endif

filetype plugin indent on
try
  colorscheme dracula
catch
  " draculaが無い場合でもエラーにならないようにする
endtry
syntax enable
