mkdir -p ~/apps
mkdir -p ~/apps/bin

# Create user
useradd -m nazarov 
passwd nazarov  
usermod -aG sudo nazarov
