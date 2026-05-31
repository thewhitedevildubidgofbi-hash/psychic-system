FROM kalilinux/kali-rolling:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    kali-desktop-xfce \
    xrdp \
    curl \
    sudo \
    wget \
    dbus-x11 \
    gnupg \
    && apt-get clean

# Create 'kali' user, add to sudoers, and allow passwordless sudo
RUN useradd -m -s /bin/bash -G sudo kali && \
    echo "kali ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Install Tailscale manually matching their exact repository paths
RUN mkdir -p /usr/share/keyrings && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /usr/share/keyrings/tailscale-archive-keyring.gpg > /dev/null && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list && \
    apt-get update && \
    apt-get install -y tailscale && \
    apt-get clean

# Force XRDP to bypass default session managers and load XFCE4 securely
RUN echo "#!/bin/sh" > /etc/xrdp/startwm.sh && \
    echo "export XDG_SESSION_DESKTOP=xfce" >> /etc/xrdp/startwm.sh && \
    echo "export XDG_CURRENT_DESKTOP=XFCE" >> /etc/xrdp/startwm.sh && \
    echo "exec dbus-run-session startxfce4" >> /etc/xrdp/startwm.sh && \
    chmod +x /etc/xrdp/startwm.sh


EXPOSE 3389

COPY startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh

WORKDIR /root
CMD ["/root/startup.sh"]
