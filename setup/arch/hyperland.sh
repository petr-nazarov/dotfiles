yay -S --noconfirm swww polkit-kde-agent sdbus-cpp-git hyprland swaync qt6-wayland rofi-lbonn-wayland-git cliphist sww grimblast iniparser waybar  brightnessctl hypridle hyprlock  network-manager-applet libsForQt5.plasma-nm blueman pipewire wireplumber pavucontrol greetd-regreet greetd-tuigreet 

# Disable iwctl and enable NEtworkManager
 
systemctl disable --now iwd
systemctl enable --now NetworkManager 

