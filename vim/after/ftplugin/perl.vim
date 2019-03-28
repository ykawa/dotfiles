set encoding=utf-8
scriptencoding utf-8
filetype on

"----------------------------------------
" cpanm Perl::Tidy
"----------------------------------------
autocmd FileType perl setlocal equalprg=perltidy\ -st

setlocal tabstop=4
setlocal shiftwidth=4
setlocal expandtab
setlocal softtabstop=4
setlocal autoindent
setlocal smartindent

filetype plugin indent on
syntax enable
