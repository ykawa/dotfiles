# backup dotfiles

# install vim

## dependencies
```bash
sudo apt-get install git build-essential ncurses-dev luajit libluajit-5.1-dev \
  python-dev python3-dev ruby-dev libperl-dev
```
```bash
sudo apt-get install -y virtualenvwrapper python3-pip python-pip
```
```bash
pip3 install --user --upgrade neovim jedi nvim-yarp vim-hug-neovim-rpc \
  pynvim Pygments
```
### (optional) pip3
```bash
pip3 install --user --upgrade tox pytest
```
## php7.2 and composer (apt)
```bash
apt-get install composer php7.2-xml php7.2-mbstring
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
### vim
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

