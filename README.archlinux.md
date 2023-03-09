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

## vim + zsh

```sh
yay -S --noconfirm vim zsh
```

```sh
chsh -s /bin/zsh
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

## disable firewalld

```sh
sudo systemctl disable --now firewalld
```

```sh
yay -Rs firewalld
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
sudo vim /etc/default/grub
```

```sh
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

`/etc/default/grub`

```diff
- GRUB_CMDLINE_LINUX=""
+ GRUB_CMDLINE_LINUX="ipv6.disable=1"
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
sudo systemctl enable --now docker.service
```

```sh
sudo usermod -aG docker $USER
```

### (Optional) If you are using a swap

```sh
sudo sed -i.bak -E -e 's/^#?LimitNOFILE=.*$/LimitNOFILE=1048576/' /lib/systemd/system/containerd.service
```

```sh
sudo systemctl daemon-reload or sudo reboot (reboot is recommended.)
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
