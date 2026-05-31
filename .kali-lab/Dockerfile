FROM kalilinux/kali-rolling:latest

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install core tools, XFCE4 desktop, and Xrdp
# (Fixed the minor warning: changed lowercase 'run' to uppercase 'RUN')
RUN apt-get update && apt-get install -y \
    kali-desktop-xfce \
    xrdp \
    curl \
    sudo \
    wget \
    dbus-x11 \
    gnupg \
    && apt-get clean

# Install Tailscale manually without using the systemd-dependent script
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.noarmor.gpg | tee /etc/apt/keyrings/tailscale-archive-keyring.gpg > /dev/null && \
    curl -fsSL https://pkgs.tailscale.com/stable/debian/bookworm.tailscale-keyring.list | tee /etc/apt/sources.list.d/tailscale.list && \
    apt-get update && \
    apt-get install -y tailscale && \
    apt-get clean

# Configure Xrdp to use XFCE
RUN echo "xfce4-session" > /root/.xsession

# Expose RDP port
EXPOSE 3389

# Copy our startup script into the container
COPY startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh

# Set working directory
WORKDIR /root

# Run the startup script on boot
CMD ["/root/startup.sh"]
