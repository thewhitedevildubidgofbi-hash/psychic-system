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

# Configure Xrdp to use XFCE for both root and kali users
RUN echo "xfce4-session" > /root/.xsession && \
    echo "xfce4-session" > /home/kali/.xsession && \
    chown kali:kali /home/kali/.xsession

EXPOSE 3389

COPY startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh

WORKDIR /root
CMD ["/root/startup.sh"]
