# Awsome
yay -S xorg awesome xorg-xinit dmenu picom xterm feh rofi acpi clipmenu network-manager-applet nm-connection-editor

###awesome-wm-widgets
git clone git@github.com:streetturtle/awesome-wm-widgets.git ~/dotfiles/display/.config/awesome/awesome-wm-widgets
git clone https://github.com/pltanton/net_widgets.git ~/dotfiles/display/.config/awesome/net_widgets

# Ly
git clone --recurse-submodules https://github.com/fairyglade/ly ~/apps/ly
cd ~/apps/ly
### Arch incons
cd ~
git clone https://github.com/horst3180/arc-icon-theme --depth 1 && cd arc-icon-theme
./autogen.sh --prefix=/usr
sudo make install

##Rofi
yay -S rofi
### Rofi power menu
git clone https://github.com/jluttine/rofi-power-menu.git ~/apps/rofi/rofi-power-menu
cp ~/apps/rofi/rofi-power-menu/rofi-power-menu ~/apps/bin/
# Hyprland
yay -S hyprland-git waybar hyprpaper otf-font-awesome dunst polkit-kde-agent qt5-wayland qt6-wayland wofi cliphist


## GUI tools for system managment
yay -S iwgtk blueman
cd ~
feh --bg-scale wallpapers/iusearchbtw.jpeg 
