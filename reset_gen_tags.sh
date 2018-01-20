#!/bin/bash
# vim: set ft=sh

# gen_tags.vim が生成する gtags 関連ファイルを全消し！
/bin/rm -rf $HOME/.cache/tags_dir .git/tags_dir

# おまけ
/bin/rm -f GTAGS GPATH GRTAGS GSYMS

exit 0

