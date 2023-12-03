# arch
## This will install the font on the system and allow you to use it in terminal emulator config (like kitty)
sudo pacman -S ttf-fira-code ttf-nerd-fonts-symbols

# ubuntu
sudo add-apt-repository universe
sudo apt update
sudo apt install fonts-firacode

## nerd fonts
echo "[-] Download fonts [-]"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/FiraCode.zip
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/3270.zip
unzip FiraCode.zip -d ~/.fonts
unzip 3270.zip -d ~/.fonts
fc-cache -fv
echo "done!"

# or install script 
git clone https://github.com/ronniedroid/getnf.git ~/apps/getnf
cd ~/apps/getnf 
./install.sh
getnf

# emoji 
yay -S noto-fonts-emoji
