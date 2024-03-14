
```sh

export SERVER_NAME=dev-server

hcloud server attach-iso $SERVER_NAME nixos-minimal-23.11.4030.9f2ee8c91ac4-x86_64-linux.iso
hcloud server poweron $SERVER_NAME
# on web interface, use the console and set the nixos user password 
ssh nixos@dev-server
sudo -i

nix-shell -p vim

parted /dev/sda -- mklabel msdos

parted /dev/sda -- mkpart primary 1MB -8GB
parted /dev/sda -- set 1 boot on
parted /dev/sda -- mkpart primary linux-swap -8GB 100%

mkfs.ext4 -L nixos /dev/sda1

mkswap -L swap /dev/sda2

mount /dev/disk/by-label/nixos /mnt
swapon /dev/sda2

nixos-generate-config --root /mnt 
vim /mnt/etc/nixos/configuration.nix
```
# You must set the option boot.loader.grub.device to specify on which disk the GRUB
# enable your user to login
# enable git , vim as system packages
# enable openssh
``` 
  services.openssh.enable = true;
  networking.firewall.enable = false;

```
```sh
nixos-install --no-root-passwd
nixos-enter --root /mnt -c 'passwd myusername'

reboot 

hcloud server poweroff $SERVER_NAME
hcloud server detach-iso $SERVER_NAME
hcloud server poweron $SERVER_NAME
passwd $USER # set your user password 




```sh


```
```sh
