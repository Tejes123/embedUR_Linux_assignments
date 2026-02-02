#!/bin/bash

# Read command-line arguments
SRC="$1"
DEST="$2"
EXT="$3"

# Check argument count
if [ $# -ne 3 ]; then
    echo "Usage: $0 <source_dir> <backup_dir> <extension>"
    exit 1
fi

# Check source directory
if [ ! -d "$SRC" ]; then
    echo "Source directory does not exist"
    exit 1
fi

# Create backup directory if not exists
if [ ! -d "$DEST" ]; then
    mkdir "$DEST" || exit 1
fi

# Enable safe globbing
shopt -s nullglob
FILES=("$SRC"/*"$EXT")
shopt -u nullglob

# If no matching files
if [ ${#FILES[@]} -eq 0 ]; then
    echo "No files to back up"
    exit 0
fi

# Export variable
export BACKUP_COUNT=0
TOTAL_SIZE=0

echo "Files selected for backup:"
for f in "${FILES[@]}"; do
    echo "$(basename "$f") - $(stat -c %s "$f") bytes"
done

# Backup files
for f in "${FILES[@]}"; do
    name=$(basename "$f")

    if [ -f "$DEST/$name" ]; then
        if [ "$f" -nt "$DEST/$name" ]; then
            cp "$f" "$DEST/$name"
            BACKUP_COUNT=$((BACKUP_COUNT + 1))
            TOTAL_SIZE=$((TOTAL_SIZE + $(stat -c %s "$f")))
        fi
    else
        cp "$f" "$DEST/$name"
        BACKUP_COUNT=$((BACKUP_COUNT + 1))
        TOTAL_SIZE=$((TOTAL_SIZE + $(stat -c %s "$f")))
    fi
done

# Create report
echo "Backup Report" > "$DEST/backup_report.log"
echo "Files backed up : $BACKUP_COUNT" >> "$DEST/backup_report.log"
echo "Total size      : $TOTAL_SIZE bytes" >> "$DEST/backup_report.log"
echo "Backup path     : $DEST" >> "$DEST/backup_report.log"
