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

## pacman-mirrors & update

```sh
sudo pacman-mirrors --fasttrack && yay -Syyuu --noconfirm
```

## vim + zsh

```sh
yay -S --noconfirm vim zsh
```

```sh
sudo chsh -s /bin/zsh $USER
```

## capslock to ctrl (on console)

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
sudo sed -i.bak -Ee 's|^KEYMAP=.*$|KEYMAP=/usr/local/share/kbd/keymaps/jp106.map|' /etc/vconsole.conf
```

## capslock to ctrl (vconsole)

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
yay -Rs firewalld
```

## ntp

```sh
yay -S ntp
```

```sh
sudo systemctl enable --now ntpd.service
```

## avahi

```sh
sudo systemctl status avahi-daemon.service
# sudo systemctl enable --now avahi-daemon.service
```

## mdns

```sh
yay -Ss nss-mdns or yay -S nss-mdns
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
# rm -rf 画像 テンプレート ダウンロード ドキュメント デスクトップ ビデオ 公開 音楽
```

## laptop when the lid is closed.

```sh
sudo sed -i.bak -Ee 's/^#?HandleLidSwitch=.*$/HandleLidSwitch=lock/' /etc/systemd/logind.conf
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
sudo sed -i.bak -Ee 's/^GRUB_CMDLINE_LINUX=""$/GRUB_CMDLINE_LINUX="ipv6.disable=1"/' /etc/default/grub
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

### perl

```sh
plenv install 5.36.0 -Dusethreads -Dman1dir=none -Dman3dir=none --as stable
```

```sh
plenv global stable
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
yay -S base-devel rust libffi libyaml openssl zlib
```

```sh
rbenv install 3.2.1
```

```sh
rbenv global system
```

## docker

```sh
yay -S docker docker-compose docker-buildx
```

```sh
sudo usermod -aG docker $USER
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
sudo sed -i.bak -Ee 's/^#?DefaultTimeoutStopSec=.*$/DefaultTimeoutStopSec=15s/' /etc/systemd/system.conf
```

`/etc/systemd/system.conf`

```diff
- #DefaultTimeoutStopSec=90s
+ DefaultTimeoutStopSec=15s
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
yay -S vagrant virtualbox-host-modules-arch virtualbox-guest-iso virtualbox
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

## onedrive

```sh
yay -S --noconfirm onedrive-abraunegg
onedrive
systemctl --user enable --now onedrive.service
journalctl --user-unit=onedrive -f
```

## other

```sh
yay -Rs pidgin pidgin-libnotify vivaldi
yay -S --noconfirm fwupd pv vim-airline-themes xclip zsh-completions
yay -S --noconfirm hyper-bin adobe-source-han-mono-jp-fonts otf-source-han-code-jp
yay -S --noconfirm google-chrome
yay -S --noconfirm dropbox
yay -S --noconfirm mozc-ut fcitx5 fcitx5-mozc-ut fcitx5-configtool
yay -S --noconfirm jetbrains-toolbox visual-studio-code-bin
yay -S --noconfirm slack-desktop zoom
```

### (Optional) If you use JetBrains IDEs with fcitx5

https://wiki.archlinux.jp/index.php/Fcitx5#JetBrains_IDE_.E3.81.A7_Fcitx5_.E3.81.AE.E4.BD.8D.E7.BD.AE.E3.81.8C.E3.81.8A.E3.81.8B.E3.81.97.E3.81.84

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
