FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV VNC_PORT=5000

# Update system and install GNOME desktop with VNC
RUN apt update && apt upgrade -y && \
    apt install -y ubuntu-desktop-minimal \
                   tigervnc-standalone-server \
                   tigervnc-common \
                   dbus-x11 \
                   supervisor \
                   python3 && \
    apt clean && rm -rf /var/lib/apt/lists/*

# Create ubuntu user or modify existing
RUN (useradd -m -s /bin/bash -u 1000 ubuntu 2>/dev/null || true) && \
    echo "ubuntu:ubuntu" | chpasswd && \
    usermod -aG sudo ubuntu

USER ubuntu
WORKDIR /home/ubuntu

# Set up VNC
RUN mkdir -p ~/.vnc && \
    echo "ubuntu" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd

USER root

# Create runtime directory
RUN mkdir -p /run/user/1000 && \
    chown ubuntu:ubuntu /run/user/1000 && \
    chmod 700 /run/user/1000

# Supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY healthcheck.py /usr/local/bin/healthcheck.py
RUN chmod +x /usr/local/bin/healthcheck.py

EXPOSE 5000 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
