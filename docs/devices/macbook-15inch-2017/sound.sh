sudo pacman -S wget make gcc linux-headers


cd ~
mkdir -p ~/drivers
git clone https://github.com/davidjo/snd_hda_macbookpro.git ~/drivers/sound
cd ~/drivers/sound
#run the following command as root or with sudo
sudo ./install.cirrus.driver.sh
#reboot
