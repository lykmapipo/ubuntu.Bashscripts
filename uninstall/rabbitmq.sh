#!/bin/bash

# Bash script to uninstall RabbitMQ, its database, docs and configurations, and
# associated third-party PPA from Ubuntu.
#
# Usage:
#   chmod +x rabbitmq.sh
#   ./rabbitmq.sh

# Enable error handling:
# - `set -e` will stop the script if any command exits with a non-zero status
# - `set -o pipefail` ensures that if any command in a pipeline fails,
# the script will exit with that command's status
set -e
# set -o pipefail

# Stop, disable and unistall RabbitMQ
if dpkg -l | grep -q "^ii  rabbitmq"; then
	# Stop RabbitMQ service
	echo "Stopping RabbitMQ service..."
	sudo systemctl stop rabbitmq-server

	# Disable RabbitMQ service from starting at boot
	echo "Disabling RabbitMQ service..."
	sudo systemctl disable rabbitmq-server

	# Uninstall RabbitMQ package
	echo "Uninstalling RabbitMQ package..."
    sudo apt-get purge --auto-remove rabbitmq-server -y
fi

# Remove RabbitMQ configuration files
if [ -d "/etc/rabbitmq/" ]; then
	echo "Removing RabbitMQ configuration files..."
	sudo rm -rf /etc/rabbitmq/
fi

# Remove RabbitMQ data directory (by default it is /var/lib/rabbitmq*)
if [ -d "/var/lib/rabbitmq*" ]; then
	echo "Removing RabbitMQ database and data files..."
	sudo rm -rf /var/lib/rabbitmq*
fi

# Remove RabbitMQ log files
if [ -d "/var/log/rabbitmq/" ]; then
	echo "Removing RabbitMQ log files..."
	sudo rm -rf /var/log/rabbitmq/
fi

# Remove any RabbitMQ documentation
if [ -d "/usr/share/doc/rabbitmq*" ]; then
	echo "Removing RabbitMQ documentation..."
	sudo rm -rf /usr/share/doc/rabbitmq*
fi

# Remove RabbitMQ user and group (if applicable)
if id "rabbitmq" &>/dev/null; then
	echo "Removing RabbitMQ user..."
	sudo deluser --remove-home rabbitmq
fi
if getent group "rabbitmq" &>/dev/null; then
	echo "Removing RabbitMQ group..."
	sudo delgroup rabbitmq
fi

echo "RabbitMQ has been completely uninstalled from your system."
