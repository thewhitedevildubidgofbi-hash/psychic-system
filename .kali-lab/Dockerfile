FROM kalilinux/kali-rolling:latest

ENV DEBIAN_FRONTEND=noninteractive

# 1. Install Systemd, FUSE, GUI, and tools
RUN apt-get update && apt-get install -y \
    systemd systemd-sysv \
    fuse libfuse2 \
    kali-desktop-xfce xrdp \
    curl sudo wget dbus-x11 gnupg \
    && apt-get clean

# 2. Mask unnecessary hardware systemd services to prevent boot hangs in Docker
RUN systemctl mask dev-mqueue.mount dev-hugepages.mount \
    systemd-remount-fs.service sys-kernel-config.mount \
    sys-kernel-debug.mount sys-fs-fuse-connections.mount \
    display-manager.service graphical.target systemd-logind.service

# 3. Install Tailscale
RUN mkdir -p /usr/share/keyrings && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list && \
    apt-get update && apt-get install -y tailscale && apt-get clean

# 4. Enable native systemd services
RUN systemctl enable xrdp tailscaled

# 5. FIX FOR ROOT GUI & SOFTWARE RENDERING
RUN echo "#!/bin/sh" > /etc/xrdp/startwm.sh && \
    echo "export XDG_SESSION_DESKTOP=xfce" >> /etc/xrdp/startwm.sh && \
    echo "export XDG_CURRENT_DESKTOP=XFCE" >> /etc/xrdp/startwm.sh && \
    echo "export LIBGL_ALWAYS_SOFTWARE=1" >> /etc/xrdp/startwm.sh && \
    echo "export GALLIUM_DRIVER=llvmpipe" >> /etc/xrdp/startwm.sh && \
    echo "exec dbus-run-session startxfce4" >> /etc/xrdp/startwm.sh && \
    chmod +x /etc/xrdp/startwm.sh

# Ensure default Kali XFCE profile is loaded
RUN cp -r /etc/xdg/xfce4/ /root/.config/ || true

# 6. Import our boot scripts
COPY entrypoint.sh /entrypoint.sh
COPY lab-init.sh /usr/local/bin/lab-init.sh
COPY lab-init.service /etc/systemd/system/lab-init.service

# Set execution permissions and enable our custom init service
RUN chmod +x /entrypoint.sh /usr/local/bin/lab-init.sh && \
    systemctl enable lab-init.service

EXPOSE 3389

# Handover to entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
