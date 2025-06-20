#!/bin/bash

# Script to prepare for offline development
# Usage: ./scripts/prepare_offline.sh

set -e

echo "Preparing for offline development..."

# Ensure vendor/cache directory exists
mkdir -p vendor/cache

# Cache all gems locally
echo "Caching gems..."
bundle cache --all

# Create a backup of the Square proxy gems
echo "Creating backup of Square proxy gems..."
mkdir -p vendor/square-gems-backup
cp vendor/cache/* vendor/square-gems-backup/

echo "Done! Your gems are now cached locally."
echo "To work offline:"
echo "1. Use 'bundle install --local' to install from cache"
echo "2. If you need to restore Square gems: cp vendor/square-gems-backup/* vendor/cache/"