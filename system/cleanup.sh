#!/bin/bash

# This script performs a series of system cleanup and maintenance tasks for Ubuntu.
#
# Usage:
#   chmod +x clean.sh
#   ./clean.sh

# Enable error handling:
# - `set -e` will stop the script if any command exits with a non-zero status
# - `set -o pipefail` ensures that if any command in a pipeline fails,
# the script will exit with that command's status
set -e
# set -o pipefail

echo "Starting system cleanup..."

# Fix broken dependencies
echo "Fixing broken dependencies..."
sudo apt-get --fix-broken install -y

# Remove unnecessary packages that were automatically installed to satisfy
# dependencies for other packages and are now no longer needed
# 'purge' remove packages and config files
# 'autoremove' remove automatically all unused packages
echo "Removing unnecessary packages..."
sudo apt-get --purge autoremove -y

# Clean up the local repository of retrieved package files
# 'autoclean' erase old downloaded archive files
echo "Cleaning up package cache..."
sudo apt-get autoclean -y

# Remove journal files older than specified time (1w)
echo "Cleaning up old journal files..."
sudo journalctl --vacuum-time=1w

echo "System cleanup complete."
