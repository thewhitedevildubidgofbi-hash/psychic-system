FROM kalilinux/kali-rolling:latest

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install core tools, XFCE4 desktop, and Xrdp
run apt-get update && apt-get install -y \
    kali-desktop-xfce \
    xrdp \
    curl \
    sudo \
    wget \
    dbus-x11 \
    && apt-get clean

# Install Tailscale
RUN curl -fsSL https://tailscale.com/install.sh | sh

# Configure Xrdp to use XFCE
RUN echo "xfce4-session" > /root/.xsession

# Expose RDP port (technically handled by --net=host, but good practice)
EXPOSE 3389

# Copy our startup script into the container
COPY startup.sh /root/startup.sh
RUN chmod +x /root/startup.sh

# Set working directory
WORKDIR /root

# Run the startup script on boot
CMD ["/root/startup.sh"]
