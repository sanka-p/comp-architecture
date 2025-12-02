## OpenROAD environment with GUI access (XFCE + VNC + noVNC)
#
# Base: Ubuntu 22.04 (Jammy)
# Provides:
#  - Non-root user (openroad)
#  - XFCE desktop, x11vnc server, noVNC (web client)
#  - OpenGL/Qt deps for OpenROAD GUI
#  - /opt/openroad as a location to drop prebuilt binaries
#
# Usage (build):
#   docker build -t openroad-gui:jammy .
#
# Usage (run with ports and volume for binaries):
#   docker run -it --rm -p 5901:5901 -p 6080:6080 \
#     -v %CD%\openroad-binaries:/opt/openroad \
#     openroad-gui:jammy
#
# After the container starts, open http://localhost:6080 for web VNC.
# Set VNC password via VNC_PASSWORD env or default "openroad".

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive \
	TZ=Etc/UTC \
	USER_NAME=openroad \
	USER_UID=1000 \
	USER_GID=1000 \
	VNC_PORT=5901 \
	NOVNC_PORT=6080 \
	DISPLAY=:1 \
	VNC_PASSWORD=openroad

# Update and install base utilities
RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y --no-install-recommends \
	  sudo ca-certificates apt-transport-https gnupg \
	  curl wget git nano tar unzip python3 python3-pip \
	  bash locales tzdata \
	  # GUI / VNC stack
	xfce4 xfce4-terminal dbus-x11 x11-xserver-utils \
	xvfb x11vnc \
	novnc websockify \
	  # OpenGL/Qt deps for OpenROAD GUI
	  libglu1-mesa libgl1-mesa-dri mesa-utils \
	  qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools \
	  # Tcl/Zlib if needed by OpenROAD runtime
	  tcl tcl-dev zlib1g zlib1g-dev && \
	apt-get clean && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN groupadd -g ${USER_GID} ${USER_NAME} && \
	useradd -m -s /bin/bash -u ${USER_UID} -g ${USER_GID} ${USER_NAME} && \
	echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Prepare directories
RUN mkdir -p /opt/openroad /home/${USER_NAME}/.vnc /var/log/novnc

# Configure locale
RUN locale-gen en_US.UTF-8 && update-locale LANG=en_US.UTF-8
ENV LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8

# Setup VNC password for x11vnc
RUN mkdir -p /home/${USER_NAME}/.vnc && \
	x11vnc -storepasswd ${VNC_PASSWORD} /home/${USER_NAME}/.vnc/passwd && \
	chown -R ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/.vnc && \
	chmod 600 /home/${USER_NAME}/.vnc/passwd

# Create entrypoint script to start VNC, noVNC, and XFCE
RUN bash -c 'cat > /usr/local/bin/start-gui.sh << "EOF"\n#!/usr/bin/env bash\nset -euo pipefail\n\nexport DISPLAY=${DISPLAY}\n\n# Allow overriding password via env\nif [ -n "${VNC_PASSWORD:-}" ]; then\n  x11vnc -storepasswd "$VNC_PASSWORD" /home/${USER_NAME}/.vnc/passwd\n  chmod 600 /home/${USER_NAME}/.vnc/passwd\n  chown ${USER_NAME}:${USER_NAME} /home/${USER_NAME}/.vnc/passwd\nfi\n\n# Start a virtual framebuffer\nXvfb ${DISPLAY} -screen 0 1280x800x24 &\nsleep 1\n\n# Launch XFCE session\n/usr/bin/xfce4-session &\n\n# Start x11vnc bound to the virtual display\nx11vnc -forever -shared -rfbport ${VNC_PORT} -rfbauth /home/${USER_NAME}/.vnc/passwd -display ${DISPLAY} -noipv6 &\n\n# Start noVNC on NOVNC_PORT\nmkdir -p /var/log/novnc\nwebsockify --web=/usr/share/novnc/ ${NOVNC_PORT} localhost ${VNC_PORT}\nEOF' && \
	chmod +x /usr/local/bin/start-gui.sh

# Optional: helper script to launch OpenROAD GUI if binaries are present in /opt/openroad
RUN bash -c 'cat > /usr/local/bin/openroad-gui.sh << "EOF"\n#!/usr/bin/env bash\nset -euo pipefail\nexport DISPLAY=${DISPLAY}\n\n# Try common binary paths\nfor bin in /opt/openroad/bin/openroad /opt/openroad/openroad /opt/openroad/bin/qtgui /opt/openroad/bin/ord; do\n  if [ -x "$bin" ]; then\n    exec "$bin" "$@"\n  fi\ndone\n\necho "OpenROAD binary not found in /opt/openroad.\nMount prebuilt binaries to /opt/openroad or rebuild inside the container."\nexit 1\nEOF' && \
	chmod +x /usr/local/bin/openroad-gui.sh

# Expose VNC and noVNC ports
EXPOSE 5901 6080

# Switch to user
USER ${USER_NAME}

# Default command starts VNC, XFCE, and noVNC
ENTRYPOINT ["/usr/local/bin/start-gui.sh"]
CMD []

