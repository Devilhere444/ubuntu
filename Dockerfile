FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:1

# Install CA certificates and update them
RUN apt update && \
    apt install -y ca-certificates && \
    update-ca-certificates && \
    apt clean

# Install required packages for GNOME + noVNC
RUN apt update && apt upgrade -y && \
    apt install -y --no-install-recommends \
                   ubuntu-desktop-minimal \
                   tigervnc-standalone-server \
                   tigervnc-common \
                   tigervnc-tools \
                   dbus-x11 \
                   supervisor \
                   python3 \
                   python3-numpy \
                   git && \
    GIT_SSL_NO_VERIFY=1 git clone --depth 1 https://github.com/novnc/noVNC.git /opt/novnc && \
    GIT_SSL_NO_VERIFY=1 git clone --depth 1 https://github.com/novnc/websockify /opt/novnc/utils/websockify && \
    ln -s /opt/novnc/vnc.html /opt/novnc/index.html && \
    apt purge -y git && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create runtime directory
RUN mkdir -p /run/user/1000 && \
    chmod 700 /run/user/1000

# Create or modify ubuntu user and set up VNC
RUN id ubuntu &>/dev/null || useradd -m -s /bin/bash -u 1000 ubuntu; \
    echo "ubuntu:ubuntu" | chpasswd && \
    usermod -aG sudo ubuntu && \
    chown ubuntu:ubuntu /run/user/1000 && \
    mkdir -p /home/ubuntu/.vnc && \
    echo "ubuntu" | /usr/bin/vncpasswd -f > /home/ubuntu/.vnc/passwd && \
    chmod 600 /home/ubuntu/.vnc/passwd && \
    chown -R ubuntu:ubuntu /home/ubuntu/.vnc

# Copy supervisor config
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 8080

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
