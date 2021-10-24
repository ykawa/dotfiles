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

" プラグイン導入 For Mac/Linux users(Winは別)
call plug#begin('~/.vim/bundle')

  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  inoremap <expr><Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
  inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
  inoremap <expr><cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'mattn/vim-lsp-icons'
  function! s:on_lsp_buffer_enabled() abort
      setlocal omnifunc=lsp#complete
      setlocal signcolumn=no
      if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
      nmap <buffer> gd <plug>(lsp-definition)
      nmap <buffer> gs <plug>(lsp-document-symbol-search)
      nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
      nmap <buffer> gr <plug>(lsp-references)
      nmap <buffer> gi <plug>(lsp-implementation)
      nmap <buffer> gt <plug>(lsp-type-definition)
      nmap <buffer> <leader>rn <plug>(lsp-rename)
      nmap <buffer> [g <plug>(lsp-previous-diagnostic)
      nmap <buffer> ]g <plug>(lsp-next-diagnostic)
      nmap <buffer> K <plug>(lsp-hover)
      nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
      nnoremap <buffer> <expr><c-d> lsp#scroll(-4)

      let g:lsp_diagnostics_enabled = 0
      let g:lsp_diagnostics_signs_enabled = 0
      let g:lsp_document_highlight_enabled = 0
      let g:lsp_document_code_action_signs_enabled = 0
  endfunction

  augroup lsp_install
      au!
      autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
  augroup END

  Plug 'hrsh7th/vim-vsnip'
  Plug 'hrsh7th/vim-vsnip-integ'

  Plug 'editorconfig/editorconfig-vim'
  Plug 'Yggdroot/indentLine'
  Plug 'andymass/vim-matchup'
  Plug 'thinca/vim-quickrun'
  Plug 'airblade/vim-gitgutter'

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

  Plug 'c9s/perlomni.vim'

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

" CTRL+l ２回で検索の強調表示を消す
nnoremap <silent><C-l><C-l> :<C-u>set nohlsearch!<CR><Esc>

let g:python3_host_prog = '/usr/bin/python3'
let g:python_host_prog = '/usr/bin/python'
let g:powerline_pycmd = 'py3'

" helpやQuickFixを 'q' で閉じる
nnoremap q <Nop>
autocmd FileType help,qf,vim,twitvim,denite nnoremap <silent><buffer>q <C-w>c

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

filetype plugin indent on
syntax enable

