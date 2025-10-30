FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1
ENV VNC_PORT=5000

# Update system and install GNOME desktop with VNC and noVNC
# Install git temporarily to clone noVNC, then remove it to save space
RUN apt update && apt upgrade -y && \
    apt install -y --no-install-recommends \
                   ubuntu-desktop-minimal \
                   tigervnc-standalone-server \
                   tigervnc-common \
                   dbus-x11 \
                   supervisor \
                   python3 \
                   python3-numpy \
                   git && \
    git clone --depth 1 https://github.com/novnc/noVNC.git /opt/novnc && \
    git clone --depth 1 https://github.com/novnc/websockify /opt/novnc/utils/websockify && \
    ln -s /opt/novnc/vnc.html /opt/novnc/index.html && \
    apt purge -y git && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /root/.cache

# Create ubuntu user or modify existing
RUN id ubuntu &>/dev/null || useradd -m -s /bin/bash -u 1000 ubuntu; \
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
