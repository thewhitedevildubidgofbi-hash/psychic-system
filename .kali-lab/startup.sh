#!/bin/bash

# Set root password for XRDP
if [ -n "$ROOT_PASSWORD" ]; then
    echo "root:$ROOT_PASSWORD" | chpasswd
    echo "Password updated successfully for root."
else
    echo "root:kali" | chpasswd
    echo "WARNING: No password secret found. Using default 'kali'."
fi

# Start Tailscale
tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &
sleep 2
tailscale up --authkey="${TAILSCALE_AUTHKEY}" --accept-routes

# Ensure run directory exists for XRDP
mkdir -p /run/dbus
service dbus start
service xrdp start

# Create Desktop for saving
mkdir -p /root/Desktop

tail -f /dev/null
