#!/bin/bash

# 1. Set the root password using the environment variable passed from GitHub Secrets
if [ -n "$ROOT_PASSWORD" ]; then
    echo "root:$ROOT_PASSWORD" | chpasswd
    echo "Password updated successfully."
else
    echo "root:kali" | chpasswd
    echo "WARNING: No ROOT_PASSWORD secret found. Using default password 'kali'."
fi

# 2. Start the Tailscale daemon in the background
tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &

# Give tailscaled a couple of seconds to spin up
sleep 2

# 3. Authenticate and bring Tailscale online
tailscale up --authkey="${TAILSCALE_AUTHKEY}" --accept-routes

# 4. Start Xrdp services (requires dbus)
service dbus start
service xrdp start

# Create the Desktop directory if it doesn't exist so you can place close.txt there
mkdir -p /root/Desktop

# Keep the script running so the container stays active
tail -f /dev/null
