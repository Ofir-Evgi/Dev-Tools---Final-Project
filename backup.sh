#!/bin/bash

MYSQL_CONTAINER_NAME="mysql-db"
MYSQL_ROOT_PASSWORD="my-secret-pw"
JOOMLA_CONTAINER_NAME="joomla-app"

BACKUP_DIR="backups"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
DB_BACKUP_FILE="$BACKUP_DIR/joomla-backup-$TIMESTAMP.sql.gz"
JOOMLA_BACKUP_FILE="$BACKUP_DIR/joomla-files-$TIMESTAMP.tar.gz"

echo "Starting backup process..."

mkdir -p "$BACKUP_DIR"

if ! docker ps | grep -q "$MYSQL_CONTAINER_NAME"; then
    echo "Error: MySQL container '$MYSQL_CONTAINER_NAME' is not running!"
    echo "Please run setup.sh first."
    exit 1
fi

echo "Backing up MySQL database..."

docker exec "$MYSQL_CONTAINER_NAME" sh -c "exec mysqldump --all-databases -uroot -p$MYSQL_ROOT_PASSWORD" | gzip > "$DB_BACKUP_FILE"

if [ $? -eq 0 ]; then
    echo "✓ Database backup completed: $DB_BACKUP_FILE"
    echo "  Backup size: $(du -h "$DB_BACKUP_FILE" | cut -f1)"
else
    echo "✗ Database backup failed!"
    exit 1
fi

echo "Backing up Joomla files..."

docker exec "$JOOMLA_CONTAINER_NAME" tar czf - /var/www/html > "$JOOMLA_BACKUP_FILE" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✓ Joomla files backup completed: $JOOMLA_BACKUP_FILE"
    echo "  Backup size: $(du -h "$JOOMLA_BACKUP_FILE" | cut -f1)"
else
    echo "✗ Joomla files backup failed!"
fi

ln -sf "$(basename "$DB_BACKUP_FILE")" "$BACKUP_DIR/latest-db-backup.sql.gz"
ln -sf "$(basename "$JOOMLA_BACKUP_FILE")" "$BACKUP_DIR/latest-files-backup.tar.gz"

echo ""
echo "Backup process completed!"
echo "Database backup: $DB_BACKUP_FILE"
echo "Files backup: $JOOMLA_BACKUP_FILE"
echo ""
echo "Available backups:"
ls -lh "$BACKUP_DIR"/*.gz 2>/dev/null || echo "No backups found"