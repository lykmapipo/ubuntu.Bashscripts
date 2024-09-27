#!/bin/bash

# Bash script to uninstall MongoDB, its database, docs and configurations, and
# associated third-party PPA from Ubuntu.
#
# Usage:
#   chmod +x mongodb.sh
#   ./mongodb.sh

# Enable error handling:
# - `set -e` will stop the script if any command exits with a non-zero status
# - `set -o pipefail` ensures that if any command in a pipeline fails,
# the script will exit with that command's status
set -e
# set -o pipefail

# Stop, disable and unistall MongoDB
if dpkg -l | grep -q "^ii  mongodb-org-server"; then
	# Stop MongoDB service
	echo "Stopping MongoDB service..."
	sudo systemctl stop mongod

	# Disable MongoDB service from starting at boot
	echo "Disabling MongoDB service..."
	sudo systemctl disable mongod

	# Uninstall MongoDB packages
	MONGODB_PACKAGES=$(dpkg -l | grep '^ii  mongodb' | awk '{print $2}')
	if [ -n "$MONGODB_PACKAGES" ]; then
		echo "Uninstalling MongoDB package..."
		echo "$MONGODB_PACKAGES" | xargs sudo apt-get purge --auto-remove -y
	fi
fi

# Remove MongoDB configuration files
if [ -d "/etc/mongodb/" ]; then
	echo "Removing MongoDB configuration files..."
	sudo rm -rf /etc/mongodb/
	sudo rm /etc/mongod.conf
fi
if [ -f "/etc/mongodb.conf" ]; then
	echo "Removing MongoDB configuration files..."
	sudo rm /etc/mongod.conf
fi

# Remove MongoDB data directory (by default it is /var/lib/mongodb)
if [ -d "/var/lib/mongodb/" ]; then
	echo "Removing MongoDB database and data files..."
	sudo rm -rf /var/lib/mongodb/
fi

# Remove MongoDB log files
if [ -d "/var/log/mongodb/" ]; then
	echo "Removing MongoDB log files..."
	sudo rm -rf /var/log/mongodb/
fi

# Remove any MongoDB documentation
if [ -d "/usr/share/doc/mongodb*" ]; then
	echo "Removing MongoDB documentation..."
	sudo rm -rf /usr/share/doc/mongodb*
fi

# Remove MongoDB user and group (if applicable)
if id "mongodb" &>/dev/null; then
	echo "Removing MongoDB user..."
	sudo deluser --remove-home mongodb
fi
if getent group "mongodb" &>/dev/null; then
	echo "Removing MongoDB group..."
	sudo delgroup mongodb
fi

# Remove MongoDB public GPG key if it was added
if ls /usr/share/keyrings/mongodb-server*.gpg &>/dev/null; then
	echo "Removing associated GPG key..."
	sudo rm /usr/share/keyrings/mongodb-server*.gpg
fi

# Remove any associated list files manually (if necessary)
if ls /etc/apt/sources.list.d/mongodb* &>/dev/null; then
	echo "Removing associated PPA files..."
	sudo rm -f /etc/apt/sources.list.d/mongodb*
fi

echo "MongoDB has been completely uninstalled from your system."
