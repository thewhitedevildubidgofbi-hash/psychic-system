#!/bin/bash

# 1. Set root password dynamically
if [ -n "$ROOT_PASSWORD" ]; then
    echo "root:$ROOT_PASSWORD" | chpasswd
else
    echo "root:kali" | chpasswd
fi

# 2. Authenticate Tailscale (systemd already started the daemon)
if [ -n "$TAILSCALE_AUTHKEY" ]; then
    tailscale up --authkey="${TAILSCALE_AUTHKEY}" --accept-routes
fi

# 3. Create the Desktop directory for the close.txt file
mkdir -p /root/Desktop
