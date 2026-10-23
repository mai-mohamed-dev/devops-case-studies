dnf install -y postgresql-server

DISK=/dev/sdb
if [ -b "$DISK" ]; then
  blkid "$DISK" >/dev/null 2>&1 || mkfs.xfs "$DISK"
  if ! mountpoint -q /var/lib/pgsql; then
    mkdir -p /var/lib/pgsql
    echo "UUID=$(blkid -s UUID -o value "$DISK") /var/lib/pgsql xfs defaults 0 0" >> /etc/fstab
    systemctl daemon-reload
    mount /var/lib/pgsql
    restorecon -R /var/lib/pgsql
    chown postgres:postgres /var/lib/pgsql
  fi
fi
install -d -o postgres -g postgres -m 700 /var/lib/pgsql/data

# Initializing the database (first run only)
[ -f /var/lib/pgsql/data/PG_VERSION ] || postgresql-setup --initdb
 
# Allowing the app VM to connect
if ! grep -q "managed-by-vagrant" /var/lib/pgsql/data/postgresql.conf; then
  cat << 'EOF' >> /var/lib/pgsql/data/postgresql.conf
# managed-by-vagrant
listen_addresses = 'localhost,192.168.56.12'
password_encryption = scram-sha-256
EOF
  cat << 'EOF' >> /var/lib/pgsql/data/pg_hba.conf
# managed-by-vagrant
host    appdb    appuser    192.168.56.11/32    scram-sha-256
EOF
fi
 

# Open the firewall for web traffic
# --permanent saves the rule so it survives a reboot (it doesn't apply to the running firewall yet)
firewall-cmd --permanent --add-rich-rule='rule family="ipv4" source address="192.168.56.12" port port="5432" protocol="tcp" accept'

# Apply the saved rules to the running firewall
firewall-cmd --reload


systemctl enable --now postgresql