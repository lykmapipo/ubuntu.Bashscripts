#!/bin/bash

# This script performs a series of system maintenance tasks for Ubuntu.
# It fixes broken dependencies, removes unnecessary packages, cleans up
# package cache, and updates and upgrades installed packages.

# Enable error handling to stop script if any command fails
set -e

echo "Starting system maintenance..."

# Fix broken dependencies
echo "Fixing broken dependencies..."
sudo apt-get --fix-broken install -y

# Remove unnecessary packages that were automatically installed to satisfy
# dependencies for other packages and are now no longer needed
echo "Removing unnecessary packages..."
sudo apt-get --purge autoremove -y

# Clean up the local repository of retrieved package files
echo "Cleaning up package cache..."
sudo apt-get autoclean -y

# Update package lists to get information on the newest versions of packages
# and their dependencies
echo "Updating package lists..."
sudo apt-get update -y

# Upgrade all installed packages to the latest version
echo "Upgrading installed packages..."
sudo apt-get upgrade -y

# Perform a distribution upgrade, which handles changing dependencies with new
# versions of packages
echo "Performing distribution upgrade..."
sudo apt-get dist-upgrade -y

# Clean up the local repository of retrieved package files again to ensure no
# old package files are left
echo "Cleaning up package cache again..."
sudo apt-get autoclean -y

# Remove any residual package files that are no longer needed
echo "Removing residual package files..."
sudo apt-get autoremove -y

echo "System maintenance complete."
