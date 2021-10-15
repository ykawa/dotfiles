# backup dotfiles

# install

```bash
git clone https://github.com/ykawa/dotfiles.git ~/dotfiles
bash ~/dotfiles/mklink.sh
```

# install vim

## dependencies

```bash
sudo apt-get install --no-install-recommends git build-essential ncurses-dev luajit libluajit-5.1-dev \
  python-dev python3-dev ruby-dev libperl-dev
```

```bash
sudo apt-get install --no-install-recommends -y virtualenvwrapper python3-pip python-pip
```

```bash
pip3 install --user --upgrade neovim jedi pynvim Pygments gevent
(or)
python -m pip --no-cache-dir install --user --upgrade neovim jedi pynvim Pygments gevent
```

### (optional) pip3

```bash
pip3 install --user --upgrade tox pytest
```

## php7.2/~7.x and composer (apt)

```bash
apt-get install --no-install-recommends composer php php-xml php-mbstring php-curl
```

### ctags

```bash
git clone https://github.com/universal-ctags/ctags.git
cd ctags/
bash autogen.sh
./configure --prefix=/usr/local --disable-aspell
make -j 4
sudo make install
```

### gnu globals

```bash
wget https://ftp.gnu.org/pub/gnu/global/global-6.6.3.tar.gz
tar xvfz global-6.6.3.tar.gz
cd global-6.6.3/
./configure --prefix=/usr/local --enable-dependency-tracking \
  --enable-shared=yes --enable-static=yes --enable-ltdl-install \
  --enable-gtagscscope
make -j 4
sudo make install
```

## vim

```bash
git clone https://github.com/vim/vim.git
cd vim
./configure --enable-fail-if-missing --with-features=huge --enable-multibyte \
  --enable-cscope --enable-luainterp --with-luajit --enable-python3interp \
  --enable-pythoninterp --enable-rubyinterp --enable-perlinterp 2>&1 \
  | tee configure.log
make -j 4
src/vim --version | grep -e python -e ruby -e perl -e lua
sudo make install
```

## restore cinnamon settings

```bash
dconf load /org/cinnamon/ < cinnamon_settings
```

## phpactor

```bash
vim(install dein plugin)
cd ~/.cache/dein/repos/github.com/phpactor/phpactor/
composer install
```
