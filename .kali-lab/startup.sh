#!/bin/bash

# 1. Set the password for the 'kali' user
if [ -n "$ROOT_PASSWORD" ]; then
    echo "kali:$ROOT_PASSWORD" | chpasswd
    echo "Password updated successfully for user 'kali'."
else
    echo "kali:kali" | chpasswd
    echo "WARNING: No password secret found. Using default 'kali'."
fi

# 2. Start Tailscale daemon
tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
sleep 2

# 3. Authenticate Tailscale
tailscale up --authkey="${TAILSCALE_AUTHKEY}" --accept-routes

# 4. Start Xrdp services
service dbus start
service xrdp start

# Create the Desktop directory for the kali user to ensure the monitor script works
mkdir -p /home/kali/Desktop
chown kali:kali /home/kali/Desktop

tail -f /dev/null
