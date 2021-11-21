" 全設定をデフォルト値に設定する
set all&
autocmd!

" tiny と small はここで終了する
if !1 | finish | endif

" vim-plug 自動インストール(curl必須)
" 詳しくは https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent execute '!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" プラグインが不足していると PlugInstall を実行する
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif

call plug#begin('~/.vim/bundle')

  Plug 'dracula/vim', { 'as': 'dracula' }
  Plug 'editorconfig/editorconfig-vim'
  Plug 'andymass/vim-matchup'

  Plug 'airblade/vim-gitgutter'
  function! GitStatus()
    let [a,m,r] = GitGutterGetHunkSummary()
    return printf('+%d ~%d -%d', a, m, r)
  endfunction
  let g:gitgutter_highlight_lines = 0
  if exists('GitGutterGetHunkSummary')
    set statusline+=%{GitStatus()}
  endif
  set updatetime=400

  Plug 'Yggdroot/indentLine'
  let g:indentLine_conceallevel = 0

  Plug 'Shougo/neosnippet.vim'
  Plug 'Shougo/neosnippet-snippets'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " 必須
  " coc-perl: cpanm -n Perl::LanguageServer
  let g:coc_global_extensions = [
        \ 'coc-clangd',
        \ 'coc-docker',
        \ 'coc-json',
        \ 'coc-markdownlint',
        \ 'coc-neosnippet',
        \ 'coc-perl',
        \ 'coc-sh',
        \ 'coc-snippets',
        \ 'coc-yaml',
  \ ]
  function! s:check_back_space() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction
  inoremap <silent><expr> <TAB>
        \ pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
  inoremap <silent><expr> <c-@> coc#refresh()
  inoremap <silent><expr> <C-k>
        \ pumvisible() ? coc#_select_confirm() :
        \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
  nmap <leader>rn <Plug>(coc-rename)            " \+r+n でリネーム処理
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  Plug 'Shougo/vimproc.vim', {'do' : 'make'}
  Plug 'thinca/vim-quickrun'
  let g:quickrun_no_default_key_mappings = 1
  let g:quickrun_config = get(g:, 'quickrun_config', {})
  let g:quickrun_config._ = {
        \ 'runner'                          : 'vimproc',
        \ 'runner/vimproc/updatetime'       : 60,
        \ 'outputter/buffer/opener'         : '8split',
        \ 'outputter/buffer/into'           : 0,
        \ 'outputter/error/success'         : 'buffer',
        \ 'outputter/error/error'           : 'quickfix',
        \ 'outputter/buffer/close_on_empty' : 1,
  \ }
  set splitbelow  " quickrun の結果を画面の下方に表示する
  nnoremap <silent> <F11> :cclose<CR>:write<CR>:QuickRun -mode n<CR>
  nnoremap <silent> <F9>  :cclose<CR>:write<CR>:QuickRun -mode n<CR>
  nnoremap <expr><silent> <C-c> quickrun#is_running() ? quickrun#sweep_sessions() : "\<C-c>"

  Plug 'twitvim/twitvim'
  let twitvim_enable_python = 1
  let twitvim_browser_cmd = 'google-chrome-stable'
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
  nnoremap [twitvim]<Leader> :<C-u>RefreshTwitter<CR><script>

  Plug 'Clavelito/indent-sh.vim'
  Plug 'Clavelito/indent-awk.vim'

  Plug 'kana/vim-operator-user'
  Plug 'rhysd/vim-clang-format'
  autocmd FileType c,cpp,objc nnoremap == :<C-u>ClangFormat<CR>
  autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)

  Plug 'ekalinin/Dockerfile.vim'
call plug#end()

set nocompatible
set encoding=utf-8
scriptencoding utf-8

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

set completeopt=longest,menu,menuone

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
syntax enable
try
  colorscheme dracula
endtry

