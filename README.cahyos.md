# cachyos

## sudo

```sh
echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' | sudo tee /etc/sudoers.d/10-installer
```

`/etc/sudoers.d/10-installer`

```diff
- %wheel ALL=(ALL:ALL) ALL
+ %wheel ALL=(ALL:ALL) NOPASSWD: ALL
```

## avahi

```sh
sudo systemctl status avahi-daemon.service
```

```sh
sudo systemctl enable --now avahi-daemon.service
```

## sshd

```sh
sudo systemctl enable --now sshd.service
```

## disable ufw

```sh
sudo systemctl disable --now ufw
```

```sh
paru --noconfirm -Rns ufw
```

## update archlinux-keyring and cachyos-keyring

```sh
sudo pacman --noconfirm -Syyuu
sudo pacman --noconfirm -S archlinux-keyring cachyos-keyring
```

## update packages

```sh
paru --noconfirm -Syu
```

## update all packages

```sh
paru -Syyuu --noconfirm
```

## vim

```sh
paru --noconfirm --needed -S vim
paru --noconfirm -Rns nano nano-syntax-highlighting
```

## zsh

```sh
paru --noconfirm --needed -S zsh zsh-completions zsh-autosuggestions zsh-syntax-highlighting zsh-theme-powerlevel10k
```

```sh
sudo chsh -s /bin/zsh $USER
```

## capslock to ctrl

```bash
sudo mkdir -p /etc/udev/hwdb.d/
```

`/etc/udev/hwdb.d/90-caps2ctrl.hwdb`
```
sudo tee /etc/udev/hwdb.d/90-caps2ctrl.hwdb << 'EOF'
# Built-in (PS/2) keyboard
evdev:atkbd:*
 KEYBOARD_KEY_3a=leftctrl    # 0x3a = CapsLock

# USB Keyboards in General
evdev:input:b0003v*p*
 KEYBOARD_KEY_70039=leftctrl  # 0x39(HID) = CapsLock

# Bluetooth keyboard (if needed)
evdev:input:b0005v*p*
 KEYBOARD_KEY_70039=leftctrl

EOF
```

```sh
sudo systemd-hwdb update
sudo udevadm trigger -s input
sudo mkinitcpio -P
```

## fonts

```sh
paru --noconfirm --needed -S \
  otf-source-han-code-jp \
  ttf-cica \
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

## mdns

```sh
paru --noconfirm --needed -S nss-mdns
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

## dotfiles

```sh
curl -L https://raw.githubusercontent.com/ykawa/dotfiles/develop/setup.sh | bash -
```

```sh
exec $SHELL -l
```

### mise (language runtime management)

```sh
mise install
mise use
```

## docker

```sh
paru --noconfirm --needed -S docker docker-compose docker-buildx
```

```sh
sudo usermod -aG docker $USER
```

```sh
newgrp docker
```

```sh
sudo systemctl enable --now docker.service
exit
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

## agetty autologin

```sh
sudo mkdir -p /etc/systemd/system/getty@tty{3,4,5}.service.d
echo -e "[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM" | sudo tee /etc/systemd/system/getty@tty3.service.d/override.conf
echo -e "[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM" | sudo tee /etc/systemd/system/getty@tty4.service.d/override.conf
echo -e "[Service]\nExecStart=\nExecStart=-/usr/bin/agetty --autologin $USER --noclear %I \$TERM" | sudo tee /etc/systemd/system/getty@tty5.service.d/override.conf
```

## qemu with virt-manager

```sh
paru --noconfirm --needed -S virt-manager qemu-full cloud-utils guestfs-tools
```

```sh
sudo usermod -aG libvirt $USER
```

```sh
newgrp libvirt
```

```sh
sudo systemctl enable --now libvirtd
exit
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

## google-chrome

```sh
paru --noconfirm --needed -S google-chrome
```

## onedrive

```sh
paru --noconfirm --needed -S onedrive-abraunegg
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
paru --noconfirm -Rns pidgin pidgin-libnotify vivaldi
```

### (Optional) If you need to install the following applications

```sh
paru --noconfirm --needed -S \
    cursor-bin \
    dropbox \
    fwupd \
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
    wl-clipboard \
    xclip \
    zoom
```

```sh
paru -S --noconfirm --needed \
    gnome-system-monitor \
    ulauncher \
    gnome-screenshot \
    python-requests python-beautifulsoup4 python-lxml python-pyperclip \
    wev \
    evince \
    xviewer \
    libreoffice-fresh \
    libreoffice-fresh-ja \
    alacritty \
    alacritty-theme \
    zellij
```

```sh
paru -S --noconfirm --needed vlc vlc-plugins-all
```

```sh
paru -S --noconfirm --needed brave-bin
```

```sh
paru --noconfirm --needed -S \
  cmake \
  shfmt \
  shellcheck \
  lsof \
  github-cli \
  pinta \
  openai-codex
```

## fcitx5 + mozc

### (Optional) If you use JetBrains IDEs with fcitx5

https://wiki.archlinux.jp/index.php/Fcitx5#JetBrains_IDE_.E3.81.A7_Fcitx5_.E3.81.AE.E4.BD.8D.E7.BD.AE.E3.81.8C.E3.81.8A.E3.81.8B.E3.81.97.E3.81.84

`Either of the following two`

```sh
# Adjust JAVA_HOME accordingly
JAVA_HOME=/usr/lib/jvm/java-11-openjdk/ paru --noconfirm --needed -S fcitx5-mozc-ext-neologd fcitx5-im
```

or

```sh
paru --noconfirm --needed -S fcitx5-mozc-ut fcitx5-im
```

or

```sh
paru --noconfirm --needed -S mozc-ut fcitx5-im
```

## systemd.mount

```sh
sudo install -m 777 -o $USER -g $USER -d /nas/{$USER,shared}/
```

```sh
echo "//nas.local/$USER /nas/$USER cifs username=$USER,password=XXXXXXX,uid=$USER,gid=$USER,noauto,x-systemd.automount,x-systemd.mount-timeout=10,x-systemd.idle-timeout=3min,_netdev 0 0" | sudo tee -a /etc/fstab
```

## genymotion

```sh
paru --noconfirm --needed -S genymotion
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
