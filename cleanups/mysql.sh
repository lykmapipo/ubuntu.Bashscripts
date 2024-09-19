#!/bin/bash

# Bash script to uninstall MySQL, its database, docs and configurations, and
# associated third-party PPA from Ubuntu.

# Enable error handling to stop script if any command fails
set -e

# Stop, disable and unistall MySQL
if dpkg -l | grep -q "^ii  mysql-server"; then
	# Stop MySQL service
	echo "Stopping MySQL service..."
	sudo systemctl stop mysql

	# Disable MySQL service from starting at boot
	echo "Disabling MySQL service..."
	sudo systemctl disable mysql

	# Uninstall MySQL package
	MYSQL_PACKAGES=$(dpkg -l | grep -q '^ii  mysql' | awk '{print $2}')
	if [ -n "$MYSQL_PACKAGES" ]; then
		echo "Uninstalling MySQL package..."
		echo "$MYSQL_PACKAGES" | xargs sudo apt-get purge --auto-remove -y
	fi
fi

# Remove MySQL configuration files
if [ -d "/etc/mysql/" ]; then
	echo "Removing MySQL configuration files..."
	sudo rm -rf /etc/mysql/
fi

# Remove MySQL data directory (by default it is /var/lib/mysql*)
if [ -d "/var/lib/mysql*" ]; then
	echo "Removing MySQL database and data files..."
	sudo rm -rf /var/lib/mysql*
fi

# Remove MySQL log files
if [ -d "/var/log/mysql/" ]; then
	echo "Removing MySQL log files..."
	sudo rm -rf /var/log/mysql/
fi

# Remove any MySQL documentation
if [ -d "/usr/share/doc/mysql*" ]; then
	echo "Removing MySQL documentation..."
	sudo rm -rf /usr/share/doc/mysql*
fi

# Remove MySQL user and group (if applicable)
if id "mysql" &>/dev/null; then
	echo "Removing MySQL user..."
	sudo deluser --remove-home mysql
fi
if getent group "mysql" &>/dev/null; then
	echo "Removing MySQL group..."
	sudo delgroup mysql
fi

echo "MySQL has been completely uninstalled from your system."
