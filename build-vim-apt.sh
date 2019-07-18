sudo apt-get install --no-install-recommends -y git build-essential ncurses-dev luajit libluajit-5.1-dev \
  python-dev python3-dev ruby-dev libperl-dev \
  virtualenvwrapper python3-pip python-pip

python3 -m pip --no-cache-dir install --user --upgrade neovim jedi pynvim Pygments gevent

apt-get install --no-install-recommends -y composer php7.2 php7.2-xml php7.2-mbstring php7.2-curl

mkdir $HOME/src/
cd $HOME/src/
git clone https://github.com/universal-ctags/ctags.git
cd ctags/
bash autogen.sh
./configure --prefix=/usr/local --disable-aspell
make -j 4
sudo make install

cd $HOME/src/
wget https://ftp.gnu.org/pub/gnu/global/global-6.6.3.tar.gz
tar xvfz global-6.6.3.tar.gz
cd global-6.6.3/
./configure --prefix=/usr/local --enable-dependency-tracking \
  --enable-shared=yes --enable-static=yes --enable-ltdl-install \
  --enable-gtagscscope
make -j 4
sudo make install

cd $HOME/src/
git clone https://github.com/vim/vim.git
cd vim
./configure --enable-fail-if-missing --with-features=huge --enable-multibyte \
  --enable-cscope --enable-luainterp --with-luajit --enable-python3interp \
  --enable-pythoninterp --enable-rubyinterp --enable-perlinterp 2>&1 \
  | tee configure.log
make -j 4
src/vim --version | grep -e python -e ruby -e perl -e lua
sudo make install

