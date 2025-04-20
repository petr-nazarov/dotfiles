
sudo systemctl enable sshd
sudo systemctl start sshd

## if firewall present
sudo ufw allow ssh
sudo ufw enable
# Cron jobs
sudo systemctl enable --now cronie.service
