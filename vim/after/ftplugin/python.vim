" .vim/after/ftplugin/python.vim

if exists('b:did_ftplugin_python')
    finish
endif
let b:did_ftplugin_python = 1

setlocal smarttab
setlocal expandtab
setlocal tabstop=4
setlocal shiftwidth=4
"setlocal foldmethod=indent
setlocal commentstring=#%s

"augroup ErrorFormat
"  autocmd BufNewFile,BufRead *.py
"  setlocal efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
"augroup END

"" PATHの自動更新関数
"" | 指定された path が $PATH に存在せず、ディレクトリとして存在している場合
"" | のみ $PATH に加える
"function! IncludePath(path)
"  " define delimiter depends on platform
"  if has('win16') || has('win32') || has('win64')
"    let delimiter = ";"
"  else
"    let delimiter = ":"
"  endif
"  let pathlist = split($PATH, delimiter)
"  if isdirectory(a:path) && index(pathlist, a:path) == -1
"    let $PATH=a:path.delimiter.$PATH
"  endif
"endfunction
"
"" ~/.pyenv/shims を $PATH に追加する
"" これを行わないとpythonが正しく検索されない
"call IncludePath(expand("~/.pyenv/shims"))


"let g:ale_python_flake8_executable = '/home/vagrant/.pyenv/shims/flake8'
"let g:ale_python_pylint_executable = '/home/vagrant/.pyenv/shims/pylint'
" let g:ale_python_pylint_options = '--rcfile ~/.pylint.rc'



if version < 600
  syntax clear
elseif exists('b:current_after_syntax')
  finish
endif

" We need nocompatible mode in order to continue lines with backslashes.
" Original setting will be restored.
let s:cpo_save = &cpo
set cpo&vim

syntax match pythonOperator "\(+\|=\|-\|\^\|\*\)"
syntax match pythonDelimiter "\(,\|\.\|:\)"
syntax keyword pythonSpecialWord self

hi link pythonSpecialWord    Special
hi link pythonDelimiter      Special

let b:current_after_syntax = 'python'

let &cpo = s:cpo_save
unlet s:cpo_save

