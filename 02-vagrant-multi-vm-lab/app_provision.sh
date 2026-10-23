#Installing Python packages
dnf install -y python3 python3-pip
pip3 install flask gunicorn psycopg2-binary

#Creating service user and app code
id flaskapp &>/dev/null || useradd --system --shell /sbin/nologin flaskapp

mkdir -p /opt/flaskapp

chown -R flaskapp:flaskapp /opt/flaskapp
chmod -R 755 /opt/flaskapp

#Creating the systemd service
cat << 'EOF' > /etc/systemd/system/flaskapp.service
[Unit]
Description=Flask app (gunicorn)
After=network.target
 
[Service]
User=flaskapp
WorkingDirectory=/opt/flaskapp
ExecStart=/usr/local/bin/gunicorn --bind 0.0.0.0:5000 app:app
Restart=always
 
[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now flaskapp

# Open the firewall for web traffic
# --permanent saves the rule so it survives a reboot (it doesn't apply to the running firewall yet)
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.56.11" port port="5000" protocol="tcp" accept'

# Apply the saved rules to the running firewall
firewall-cmd --reload
