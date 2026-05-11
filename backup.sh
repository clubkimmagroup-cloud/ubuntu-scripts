#!/bin/bash
# Backup home directory to a destination folder
# Usage: ./backup.sh [destination]

set -e

DEST="${1:-/media/backup}"
DATE=$(date +%Y-%m-%d_%H-%M)
BACKUP_NAME="home_backup_$DATE.tar.gz"
SOURCE="$HOME"

if [ ! -d "$DEST" ]; then
    echo "Destination $DEST does not exist. Creating..."
    mkdir -p "$DEST"
fi

echo "=== Backing up $SOURCE → $DEST/$BACKUP_NAME ==="

tar --exclude="$HOME/.cache" \
    --exclude="$HOME/.local/share/Trash" \
    --exclude="$HOME/snap/*/common/.cache" \
    -czf "$DEST/$BACKUP_NAME" "$SOURCE"

SIZE=$(du -sh "$DEST/$BACKUP_NAME" | cut -f1)
echo "Backup complete: $DEST/$BACKUP_NAME ($SIZE)"
