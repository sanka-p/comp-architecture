# Makefile for building and running OpenROAD GUI container (Ubuntu 22.04, XFCE + x11vnc + noVNC)

# Image and container settings
IMAGE_NAME ?= openroad-gui:jammy
CONTAINER_NAME ?= openroad-gui
# Host path to prebuilt OpenROAD binaries; adjust as needed
# Example: f:/Sanka/VLSI/openroad-binaries on Windows
HOST_OPENROAD_BIN ?= $(CURDIR)/bin

# Ports
VNC_PORT ?= 5901
NOVNC_PORT ?= 6080

# VNC password (override with: make run VNC_PASS=YourPass)
VNC_PASS ?= openroad

.PHONY: build run run-detach stop logs clean help

help:
	@echo "Targets:"
	@echo "  build        - Build the Docker image"
	@echo "  run          - Run container interactive, map ports, mount binaries"
	@echo "  run-detach   - Run container in background"
	@echo "  stop         - Stop the running container"
	@echo "  logs         - Tail container logs"
	@echo "  clean        - Remove image and container (if exist)"

build:
	docker build -t $(IMAGE_NAME) .

run:
	docker run -d \
		--name $(CONTAINER_NAME) \
		-p $(VNC_PORT):$(VNC_PORT) \
		-p $(NOVNC_PORT):$(NOVNC_PORT) \
		-e VNC_PASSWORD=$(VNC_PASS) \
		-v $(HOST_OPENROAD_BIN):/opt/openroad \
		$(IMAGE_NAME)

stop:
	- docker stop $(CONTAINER_NAME)

logs:
	docker logs -f $(CONTAINER_NAME)

clean:
	- docker rm -f $(CONTAINER_NAME)
	- docker rmi -f $(IMAGE_NAME)
