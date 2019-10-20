set encoding=utf-8
filetype off

"----------------------------------------
" cpanm Perl::Tidy
"----------------------------------------
autocmd FileType perl setlocal equalprg=perltidy\ -st

filetype plugin indent on
syntax enable
