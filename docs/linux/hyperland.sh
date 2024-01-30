yay -S --noconfirm swww polkit-kde-agent sdbus-cpp-git hyprland swaync grim slurp  xdg-desktop-portal-hyprland
yay -S --noconfirm pipewire wireplumber polkit-kde-agent  qt6-wayland rofi-lbonn-wayland-git cliphist sww grim slurp grimblast iniparser --noconfirm
# Waybar 
cd ~/apps 
git clone https://github.com/Alexays/Waybar
cd Waybar
meson build
#ninja -C build
#./build/waybar
# If you want to install it
ninja -C build install

## 
# If needed 
systemctl start --user xdg-desktop-portal-hyprland

