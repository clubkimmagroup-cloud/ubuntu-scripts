#!/bin/bash
# Create a new sudo user
# Usage: ./create-user.sh <username>

set -e

if [ -z "$1" ]; then
    echo "Usage: $0 <username>"
    exit 1
fi

USERNAME="$1"

sudo adduser "$USERNAME"
sudo usermod -aG sudo "$USERNAME"

echo "=== User '$USERNAME' created and added to sudo group ==="
id "$USERNAME"
