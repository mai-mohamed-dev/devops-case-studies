# Install Nginx (the web server / reverse proxy for this VM)
dnf install -y nginx

# Start Nginx now and make it start automatically on every boot
systemctl enable --now nginx

# Open the firewall for web traffic
# --permanent saves the rule so it survives a reboot (it doesn't apply to the running firewall yet)
firewall-cmd --permanent --add-service=http     # port 80
firewall-cmd --permanent --add-service=https    # port 443

# Apply the saved rules to the running firewall
firewall-cmd --reload

# SELinux: allow Nginx to make outgoing network connections (needed to proxy to the app VM)
# -P makes the change permanent across reboots
setsebool -P httpd_can_network_connect 1
mkdir -p /var/www/myapp
chown -R vagrant:vagrant /var/www/myapp
chmod -R 755 /var/www/myapp