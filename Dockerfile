FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV VNC_PORT=6901
ENV VNC_PW=1234

# Update system and install GNOME, VNC, and noVNC
RUN apt update && apt upgrade -y && \
    apt install -y gnome-session gdm3 dbus-x11 x11-xserver-utils \
                   supervisor novnc websockify tigervnc-standalone-server \
                   tigervnc-common xfce4-terminal curl wget sudo && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Create or configure VNC user
RUN id -u ubuntu &>/dev/null || useradd -m -s /bin/bash -u 1000 ubuntu; \
    echo "ubuntu:ubuntu" | chpasswd && \
    usermod -aG sudo ubuntu

USER ubuntu
WORKDIR /home/ubuntu

# Set up VNC password and user runtime directory
RUN mkdir -p ~/.vnc && \
    echo "1234" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd && \
    mkdir -p /home/ubuntu/.config /home/ubuntu/.local/share

USER root

# Create user runtime directory for D-Bus
RUN mkdir -p /run/user/1000 && chown ubuntu:ubuntu /run/user/1000 && chmod 700 /run/user/1000

# Prepare X11 socket directory
RUN mkdir -p /tmp/.X11-unix && chmod 1777 /tmp/.X11-unix

# Supervisor config for running everything
RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 6901
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
