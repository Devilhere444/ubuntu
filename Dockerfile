FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

# Install minimal GNOME desktop only
RUN apt update && apt upgrade -y && \
    apt install -y --no-install-recommends \
                   ubuntu-desktop-minimal \
                   dbus-x11 \
                   python3 && \
    apt autoremove -y && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create ubuntu user
RUN useradd -m -s /bin/bash -u 1000 ubuntu && \
    echo "ubuntu:ubuntu" | chpasswd && \
    usermod -aG sudo ubuntu

# Create runtime directory for GNOME
RUN mkdir -p /run/user/1000 && \
    chown ubuntu:ubuntu /run/user/1000 && \
    chmod 700 /run/user/1000

# Simple healthcheck server
COPY healthcheck.py /healthcheck.py
RUN chmod +x /healthcheck.py

EXPOSE 8080

CMD ["/usr/bin/python3", "/healthcheck.py"]
