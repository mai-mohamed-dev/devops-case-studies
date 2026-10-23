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

cat << 'EOF' > /etc/nginx/conf.d/myapp.conf
server {
    listen 80;
    server_name myapp.com;
    root /var/www/myapp;
    index index.html;

    # custom error pages
    error_page 404 /404.html;
    location = /404.html {
        root /var/www/myapp;
    }
    # Serve your static frontend app
    location / {
        root /var/www/myapp;
        index index.html;
        try_files $uri $uri/ /index.html;
    }
    # Reverse proxy: /api/health  ->  http://app:5000/health
    location /api/ {
        proxy_pass http://192.168.56.10:5000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_connect_timeout 3s;
    }
}
EOF

#dns configuration (Skip If you are using a public DNS server)
#cat << 'EOF' > /etc/hosts
#192.168.56.10 myapp.com
#EOF

nginx -t
systemctl enable nginx
systemctl restart nginx