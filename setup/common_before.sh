# Network through wifi in arch install
iwctl
device list
assuming name is wlan0
station wlan0 scan
station wlan0 get-networks
station wlan0 connect YourNetworkName
exit

mkdir -p ~/apps
mkdir -p ~/apps/bin

# Create user
useradd -m nazarov 
passwd nazarov  
usermod -aG sudo nazarov
