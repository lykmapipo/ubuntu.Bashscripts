#!/bin/bash

# Bash script to uninstall Redis, its database, docs and configurations, and
# associated third-party PPA from Ubuntu.

# Enable error handling to stop script if any command fails
set -e

# Stop, disable and unistall Redis
if dpkg -l | grep "^ii  redis-server"; then
	# Stop Redis service
	echo "Stopping Redis service..."
	sudo systemctl stop redis-server

	# Disable Redis service from starting at boot
	echo "Disabling Redis service..."
	sudo systemctl disable redis-server

	# Uninstall Redis package
	echo "Uninstalling Redis package..."
	sudo apt-get purge --auto-remove redis-server redis-tools -y
fi

# Remove Redis configuration files
if [ -d "/etc/redis/" ]; then
	echo "Removing Redis configuration files..."
	sudo rm -rf /etc/redis/
fi

# Remove Redis data directory (by default it is /var/lib/redis)
if [ -d "/var/lib/redis/" ]; then
	echo "Removing Redis database and data files..."
	sudo rm -rf /var/lib/redis/
fi

# Remove Redis log files
if [ -d "/var/log/redis/" ]; then
	echo "Removing Redis log files..."
	sudo rm -rf /var/log/redis/
fi

# Remove any Redis documentation
if [ -d "/usr/share/doc/redis*" ]; then
	echo "Removing Redis documentation..."
	sudo rm -rf /usr/share/doc/redis*
fi

# Remove Redis user and group (if applicable)
if id "redis" &>/dev/null; then
	echo "Removing Redis user..."
	sudo deluser --remove-home redis
fi
if getent group "redis" &>/dev/null; then
	echo "Removing Redis group..."
	sudo delgroup redis
fi

# Remove any third-party Redis PPA if it was added
PPA_NAME="chris-lea/redis-server"
PPA_FILE="chris-lea-ubuntu-redis-server"
PPA_KEYRING_FILE="/etc/apt/trusted.gpg.d/chris-lea_ubuntu_redis-server.gpg";
if ls /etc/apt/sources.list.d/*"$PPA_FILE"* &>/dev/null; then
    # Remove the PPA
    if sudo add-apt-repository --remove ppa:"$PPA_NAME" -y; then
    	echo "Removing Redis PPA..."
    fi 

    # Remove any associated PPA files manually (if necessary)
    if sudo rm -f /etc/apt/sources.list.d/*"$PPA_FILE"*; then
    	echo "Removing associated PPA files..."
    fi
fi

# Remove any third-party Redis PPA GPG key if it was added
if [ -f "$PPA_KEYRING_FILE" ]; then
    KEY_ID=$(gpg --no-default-keyring --keyring "$PPA_KEYRING_FILE" --list-keys | grep -A 1 pub | awk '{print $1}' | tail -n1)
    if [ -n "$KEY_ID" ]; then
    	if sudo gpg --no-default-keyring --keyring "$PPA_KEYRING_FILE" --delete-keys "$KEY_ID"; then
    		echo "Removing associated GPG key..."
    	fi
    fi
fi

echo "Redis and associated PPA have been completely uninstalled from your system."
