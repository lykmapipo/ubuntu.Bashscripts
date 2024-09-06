#!/bin/bash

# This script performs a series of system update and maintenance tasks for Ubuntu.
# It updates package lists, upgrades installed packages, and performs a
# distribution upgrade.

# Enable error handling: 
# - `set -e` will stop the script if any command exits with a non-zero status
# - `set -o pipefail` ensures that if any command in a pipeline fails,
# the script will exit with that command's status
set -e
set -o pipefail

echo "Starting system update..."

# Update package lists to get information on the newest versions of packages
# and their dependencies
# 'update' retrieve new lists of packages
echo "Updating package lists (ignoring broken links)..."
sudo apt-get update --fix-missing -y || true

# Upgrade all installed packages to the latest version available in the
# current repository
# 'upgrade' perform an upgrade
echo "Upgrading installed packages..."
sudo apt-get upgrade -y

# Perform a distribution upgrade, which handles changing dependencies with new
# versions of packages
echo "Performing distribution upgrade..."
sudo apt-get dist-upgrade -y

echo "System update complete."
