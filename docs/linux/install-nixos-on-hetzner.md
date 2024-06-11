
```sh

export SERVER_NAME=dev-server

hcloud server attach-iso $SERVER_NAME nixos-minimal-23.11.4030.9f2ee8c91ac4-x86_64-linux.iso
hcloud server poweron $SERVER_NAME
# on web interface, use the console and set the nixos user password 
ssh nixos@$SERVER_NAME
```
```sh
sudo -i


parted /dev/sda -- mklabel msdos

parted /dev/sda -- mkpart primary 1MB -8GB
parted /dev/sda -- set 1 boot on
parted /dev/sda -- mkpart primary linux-swap -8GB 100%

mkfs.ext4 -L nixos /dev/sda1

mkswap -L swap /dev/sda2

mount /dev/disk/by-label/nixos /mnt
swapon /dev/sda2

nix-shell -p vim
nixos-generate-config --root /mnt 
vim /mnt/etc/nixos/configuration.nix
```
# You must set the option boot.loader.grub.device to specify on which disk the GRUB
# enable your user to login
# enable git , vim as system packages
# enable openssh
# change the os hostname to $SERVER_NAME
``` 
  services.openssh.enable = true;
  networking.firewall.enable = false;

```
```sh
nixos-install --no-root-passwd
nixos-enter --root /mnt -c 'passwd myusername'

exit

hcloud server poweroff $SERVER_NAME
hcloud server detach-iso $SERVER_NAME
hcloud server poweron $SERVER_NAME


git clone https://github.com/petr-nazarov/dotfiles.git 
cp /etc/nixos/hardware-configuration.nix dotfiles/nixos/system/hardware/
cd  dotfiles/nixos/system/hardware/
rm dev-server-hardware-configuration.nix
mv hardware-configuration.nix dev-server-hardware-configuration.nix
git add .
mkdir ~/.ssh
cd ~/.ssh
ssh-keygen -t ed25519 -f personal.github
cp personal.github.pub id_rsa.pub
cp personal.github id_rsa
git remote remove origin
git remote add origin git@github.com:petr-nazarov/dotfiles.git
git branch --set-upstream-to=origin/master master

sudo nixos-rebuild switch --flake .#dev-server
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz home-manager
sudo nix-channel --update
nix-shell '<home-manager>' -A install
home-manager switch --flake .#nazarov-dev-server --impure
sudo reboot


ssh-copy-id -i dev-server.pub nazarov@dev-server

# Dont forget to fix kitty 
kitty +kitten  ssh nazarov@dev-server

```
```sh




```sh


```
```sh
