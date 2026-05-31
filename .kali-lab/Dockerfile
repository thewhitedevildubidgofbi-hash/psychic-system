FROM kalilinux/kali-rolling:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install core GUI, XRDP, and Tailscale dependencies
RUN apt-get update && apt-get install -y \
    kali-desktop-xfce \
    xrdp \
    curl \
    sudo \
    wget \
    dbus-x11 \
    gnupg \
    && apt-get clean

# Install Tailscale
RUN mkdir -p /usr/share/keyrings && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list && \
    apt-get update && \
    apt-get install -y tailscale && \
    apt-get clean

# FIX FOR ROOT GUI: Force XRDP to wrap XFCE4 in an isolated D-Bus session
RUN echo "#!/bin/sh" > /etc/xrdp/startwm.sh && \
    echo "export XDG_SESSION_DESKTOP=xfce" >> /etc/xrdp/startwm.sh && \
    echo "export XDG_CURRENT_DESKTOP=XFCE" >> /etc/xrdp/startwm.sh && \
    echo "export LIBGL_ALWAYS_SOFTWARE=1" >> /etc/xrdp/startwm.sh && \
    echo "export GALLIUM_DRIVER=llvmpipe" >> /etc/xrdp/startwm.sh && \
    echo "exec dbus-run-session startxfce4" >> /etc/xrdp/startwm.sh && \
    chmod +x /etc/xrdp/startwm.sh

# Ensure default Kali XFCE profile is loaded for root
RUN cp -r /etc/xdg/xfce4/ /root/.config/ || true

EXPOSE 3389

COPY startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh

WORKDIR /root
CMD ["/root/startup.sh"]
