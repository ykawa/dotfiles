# archlinux

## sudo

```sh
echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/10-installer
```

`/etc/sudoers.d/10-installer`

```diff
- %wheel ALL=(ALL:ALL) ALL
+ %wheel ALL=(ALL:ALL) NOPASSWD: ALL
```

## sshd

```sh
sudo systemctl enable --now sshd.service
```

## update archlinux-keyring

```sh
sudo pacman --noconfirm -S archlinux-keyring
```

## update packages

```sh
sudo pacman --noconfirm -Syu
```

## add yay

```sh
sudo pacman --noconfirm -S yay
```

## pacman-mirrors & update

```sh
sudo pacman-mirrors -c Japan && yay -Syyuu --noconfirm
```

or

```sh
sudo pacman-mirrors --fasttrack && yay -Syyuu --noconfirm
```

## update all packages

```sh
yay -Yc --noconfirm && sudo rm -rf ~/.cache/yay/ ~/.cache/bazel/ && LANG=C yay -Syyuu --noconfirm
```

## base-devel

```sh
yay --noconfirm -S base-devel
```

## vim

```sh
yay --noconfirm -S vim python-pynvim
```

## zsh

```sh
yay --noconfirm -S zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting zsh-theme-powerlevel10k
```

```sh
sudo chsh -s /bin/zsh $USER
```

## capslock to ctrl (virtual console)

```sh
sudo mkdir -p /usr/local/share/kbd/keymaps/
```

```sh
zcat /usr/share/kbd/keymaps/i386/qwerty/jp106.map.gz \
| sed -E -e 's/keycode  58 =.*$/keycode  58 = Control/' \
| sudo tee /usr/local/share/kbd/keymaps/jp106.map
```

```sh
sudo loadkeys /usr/local/share/kbd/keymaps/jp106.map
```

```sh
sudo sed -i.bak -E -e 's|^KEYMAP=.*$|KEYMAP=/usr/local/share/kbd/keymaps/jp106.map|' /etc/vconsole.conf
```

## capslock to ctrl (console)

```sh
sudo sed -i.bak -E -e 's/^XKBOPTIONS=.*$/XKBOPTIONS="ctrl:nocaps"/' /etc/default/keyboard
```

`/etc/default/keyboard`

```diff
- XKBOPTIONS=""
+ XKBOPTIONS="ctrl:nocaps"
```

## disable firewalld

```sh
sudo systemctl disable --now firewalld
```

```sh
yay --noconfirm -Rs firewalld
```

## fonts

```sh
yay --noconfirm -S \
  adobe-source-code-pro-fonts \
  adobe-source-han-sans-jp-fonts \
  adobe-source-han-serif-otc-fonts \
  otf-source-han-code-jp \
  ttf-cica \
  ttf-font-awesome \
  ttf-jetbrains-mono \
  ttf-jetbrains-mono-nerd \
  ttf-ms-win11-auto-japanese
```

## systemd-timesyncd

```sh
sudo systemctl status systemd-timesyncd
```

```sh
sudo timedatectl set-ntp true
sudo systemctl enable --now systemd-timesyncd.service
```

## avahi

```sh
sudo systemctl status avahi-daemon.service
# sudo systemctl enable --now avahi-daemon.service
```

## mdns

```sh
yay --noconfirm -S nss-mdns
```

```sh
sudo vim /etc/nsswitch.conf
```

`/etc/nsswitch.conf` add `mdns4_minimal [NOTFOUND=return]`

```diff
- hosts: mymachines resolve [!UNAVAIL=return] files myhostname dns
+ hosts: mymachines mdns4_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns
```

## JP to C for folders in home directory

```sh
LANG=C xdg-user-dirs-update --force
```

```sh
ls | perl -CIO -nle 'print unless /[a-z]/' | xargs rm -rv
```

or

```sh
rm -rf 画像 テンプレート ダウンロード ドキュメント デスクトップ ビデオ 公開 音楽
```

## laptop when the lid is closed

```sh
sudo sed -i.bak -E -e 's/^#?HandleLidSwitch=.*$/HandleLidSwitch=lock/' /etc/systemd/logind.conf
```

`/etc/systemd/logind.conf`

```diff
[Login]
- HandleLidSwitch=suspend
+ HandleLidSwitch=lock
```

```sh
sudo systemctl restart systemd-logind.service
```

## disable ipv6

grub or systemd-boot

### systemd-boot

```sh
sudo vim /efi/loader/entries/(* device UUID with kernel version)-arch1-1.conf
```

`/efi/loader/entries/(* device UUID with kernel version)-arch1-1.conf`

```diff
- options root=/dev/sda2 quiet splash
+ options root=/dev/sda2 quiet splash ipv6.disable=1
```

### grub

```sh
sudo sed -i.bak -E -e 's/^GRUB_CMDLINE_LINUX=""$/GRUB_CMDLINE_LINUX="ipv6.disable=1"/' /etc/default/grub
```

`/etc/default/grub`

```diff
- GRUB_CMDLINE_LINUX=""
+ GRUB_CMDLINE_LINUX="ipv6.disable=1"
```

```sh
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

## configure sshd (ipv4, X11Forwarding)

```sh
sudo sed -i.bak -E -e 's/^#?AddressFamily .*$/AddressFamily inet/' \
            -e 's/^#?X11Forwarding .*$/X11Forwarding yes/' /etc/ssh/sshd_config
```

```sh
sudo systemctl restart sshd.service
```

```sh
sudo systemctl status sshd.service
```

## dotfiles

```sh
curl -L https://raw.githubusercontent.com/ykawa/dotfiles/develop/setup.sh | bash -
```

```sh
exec $SHELL -l
```

### (Optional) If you want to come vim setup

```sh
vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"
```

### perl

```sh
curl -s "https://api.github.com/repos/Perl/perl5/tags" | perl ~/dotfiles/perl_ver.pl
```

```sh
plenv install 5.38.2 -Dusethreads -Dman1dir=none -Dman3dir=none --as stable
```

```sh
plenv local stable
```

```sh
plenv install-cpanm
```

### (Optional) If you do not use distribution cpan

```sh
rm -rf ~/perl5
```

### (Optional) If you need a development environment

```sh
# e.g.
cpanm -n Perl::LanguageServer Carton Bundle::Camelcade App::PRT App::EditorTools App::perlimports
```

### ruby

```sh
curl -s "https://api.github.com/repos/ruby/ruby/tags" | perl ~/dotfiles/ruby_ver.pl
```

```sh
yay --noconfirm -S rustup libffi libyaml openssl zlib
```

```sh
rustup default stable
```

```sh
rbenv communize --all
```

```sh
rbenv install 3.3.2
```

### (Optional) If the system ruby is installed

```sh
rbenv global system
```

## docker

```sh
yay --noconfirm -S docker docker-compose docker-buildx
```

```sh
sudo usermod -aG docker $USER
```

```sh
newgrp docker
```

```sh
sudo systemctl enable --now docker.service
```

### (Optional) If you are using a swap

```sh
sudo sed -i.bak -E -e 's/^#?LimitNOFILE=.*$/LimitNOFILE=1048576/' /lib/systemd/system/containerd.service
```

```sh
sudo systemctl daemon-reload or sudo reboot (reboot is recommended.)
```

```sh
docker run --init --rm -e MYSQL_ROOT_PASSWORD=pass -e MYSQL_USER=user -e MYSQL_PASSWORD=pass -e MYSQL_DATABASE=testdb mysql:5.7
```

## systemd

```sh
sudo sed -i.bak -E -e 's/^#?DefaultTimeoutStopSec=.*$/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf
```

`/etc/systemd/system.conf`

```diff
- #DefaultTimeoutStopSec=90s
+ DefaultTimeoutStopSec=15s
```

## PulseAudio

### (Optional) If pulseaudio delay measures are required

```sh
sudo sed -i.bak -E -e 's/^; default-sample-rate =.*$/default-sample-rate = 44100/' \
            -e 's/^; alternate-sample-rate =.*$/alternate-sample-rate = 44100/' \
            /etc/pulse/daemon.conf
```

`/etc/pulse/daemon.conf`

```diff
- ; default-sample-rate = 44100
- ; alternate-sample-rate = 48000
+ default-sample-rate = 44100
+ alternate-sample-rate = 44100
```

## agetty autologin

```sh
sudo mkdir -p /etc/systemd/system/getty@tty{1,2,3}.service.d
echo -e "[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM" | sudo tee /etc/systemd/system/getty@tty1.service.d/override.conf
echo -e "[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM" | sudo tee /etc/systemd/system/getty@tty2.service.d/override.conf
echo -e "[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM" | sudo tee /etc/systemd/system/getty@tty3.service.d/override.conf
```

## vagrant with virtualbox

```sh
yay --noconfirm -S vagrant virtualbox-host-modules-arch virtualbox-guest-iso virtualbox
```

```sh
sudo usermod -aG vboxusers $USER
```

```sh
sudo modprobe vboxdrv or sudo reboot (reboot is recommended.)
```

```sh
vagrant plugin install vagrant-vbguest vagrant-share vagrant-env
```

## qemu with virt-manager

```sh
yay --noconfirm -S virt-manager qemu-desktop
```

```sh
sudo usermod -aG libvirt $USER
```

```sh
newgrp libvirt
```

```sh
sudo systemctl enable --now libvirtd
```

```sh
sudo systemctl status libvirtd
```

### add bridge

`It is recommended that the following operations be performed on the NetworkManager Applet`

```sh
sudo nmcli connection add type bridge con-name br0 ifname br0
sudo nmcli connection add type ethernet con-name br0-port-1 ifname eno1 master br0
sudo nmcli connection up br0
sudo nmcli connection up br0-port-1
```

```sh
sudo nmcli connection modify br0 ipv4.dns "94.140.14.14,94.140.15.15"
sudo nmcli connection modify br0 ipv4.ignore-auto-dns yes
sudo nmcli connection modify br0 ipv6.dns "2a10:50c0::ad1:ff,2a10:50c0::ad2:ff"
sudo nmcli connection modify br0 ipv6.ignore-auto-dns yes
sudo nmcli connection down br0
sudo nmcli connection up br0
```

## onedrive

```sh
yay --noconfirm -S onedrive-abraunegg
```

```sh
onedrive
```

```sh
systemctl --user enable --now onedrive.service
```

```sh
journalctl --user-unit=onedrive -f
```

## other

### (Optional) If you no need pidgin and vivaldi.

```sh
yay --noconfirm -Rs pidgin pidgin-libnotify vivaldi
```

### (Optional) If you need to install the following applications

```sh
yay --noconfirm -S \
  copyq \
  cursor-bin \
  dropbox \
  fwupd \
  google-chrome \
  grc \
  hyper-bin \
  jetbrains-toolbox \
  jq \
  nkf \
  peco \
  pv \
  slack-desktop \
  unarchiver \
  wezterm \
  xclip \
  zoom
```

## fcitx5 + mozc

### (Optional) If you use JetBrains IDEs with fcitx5

https://wiki.archlinux.jp/index.php/Fcitx5#JetBrains_IDE_.E3.81.A7_Fcitx5_.E3.81.AE.E4.BD.8D.E7.BD.AE.E3.81.8C.E3.81.8A.E3.81.8B.E3.81.97.E3.81.84

`Either of the following two`

```sh
# Adjust JAVA_HOME accordingly
JAVA_HOME=/usr/lib/jvm/java-11-openjdk/ yay --noconfirm -S fcitx5-mozc-ext-neologd fcitx5-im
```

```sh
yay --noconfirm -S mozc-ut fcitx5-mozc-ut fcitx5-im
```

## systemd.mount

```sh
sudo install -m 777 -o $USER -g $USER -d /nas/{$USER,shared}/
```

```sh
echo "//nas.local/$USER /nas/$USER cifs username=$USER,password=XXXXXXX,uid=$USER,gid=$USER,noauto,x-systemd.automount,x-systemd.mount-timeout=10,x-systemd.idle-timeout=3min,_netdev 0 0" | sudo tee -a /etc/fstab
```

## .xinitrc

### key repeat

```sh
echo "xset r rate 200 40" | tee -a ~/.xinitrc
```

## .profile

### Suppress output to .xsession-errors.

```sh
echo 'export ERRFILE=/dev/null' | tee -a ~/.profile
```

`~/.profile`

```diff
+ export ERRFILE=/dev/null
```

## genymotion

```sh
yay --noconfirm -S genymotion
```

### (Optional) If you need to install google play services for android9 (pie)

* add virtual device
  * android should specify version 9 (pie)
* start virtual device
* click `open gapss` (It should be on the right-hand side of the window)
  * Reboot when installation is complete
* Download the Genymotion-ARM-Translation_for_9.0.zip from below and drag & drop it onto the virtual device to install
  * https://github.com/m9rco/Genymotion_ARM_Translation/tree/master
  * Reboot when installation is complete
* You can install kindle, kobo and others

### (Optional) If you need to install google play services for android11 (api30)

* add virtual device
  * android should specify version 11
* start virtual device
* click `open gapss` (It should be on the right-hand side of the window)
  * Reboot when installation is complete
* https://github.com/niizam/Genymotion_A11_libhoudini
  * Download libhoudini from releases page.
  * Drag and drop system.zip to emulator
  * Restart the emulator
  * /opt/genymotion/tools/adb shell
  * mount -o rw,remount /
  * write /system/build.prop and /system/vendor/build.prop

### (Optional) If you need to increase the capacity of the virtual device

* stop virtual device
* execute the following command

```sh
/opt/genymotion/qemu/x86_64/bin/qemu-img info ~/.Genymobile/Genymotion/deployed/[your device]/data.qcow2
```

* example of increasing to 64GB

```sh
/opt/genymotion/qemu/x86_64/bin/qemu-img resize ~/.Genymobile/Genymotion/deployed/[your device]/data.qcow2 64G
```

* start virtual device
* execute the following command

```sh
/opt/genymotion/tools/adb shell
```

* The following works on android
  * The prompt should be `vbox86p:/ #`

```sh
df -h (to find the device in `/data`, probably `/dev/block/vdb3`)
resize2fs /dev/block/vdb3
exit
```

* restart virtual device

## lsp

### awk language server

```sh
npm install -g awk-language-server
```

### bash language server

```sh
npm install -g bash-language-server
```

### css language server

```sh
npm install -g vscode-css-languageserver-bin
```

### html language server

```sh
npm install -g vscode-html-languageserver-bin
```

### json language server

```sh
npm install -g vscode-json-languageserver
```

### perl language server

```sh
cpanm -n Perl::LanguageServer
```

### solargraph

```sh
gem install solargraph
```

### typescript-language-server

```sh
npm install -g typescript-language-server typescript
```
