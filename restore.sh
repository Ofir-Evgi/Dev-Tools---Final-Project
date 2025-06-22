#!/bin/bash

MYSQL_CONTAINER_NAME="mysql-db"
MYSQL_ROOT_PASSWORD="my-secret-pw"
MYSQL_DATABASE="our-app-db"
JOOMLA_CONTAINER_NAME="joomla-app"
MYSQL_USER="root"

BACKUP_DIR="backups"
DB_BACKUP_FILE="$BACKUP_DIR/latest-db-backup.sql.gz"
JOOMLA_BACKUP_FILE="$BACKUP_DIR/latest-files-backup.tar.gz"

echo "Starting restore process..."

if [ ! -f "$DB_BACKUP_FILE" ]; then
    echo "Error: Database backup file not found: $DB_BACKUP_FILE"
    echo "Available backups:"
    ls -la "$BACKUP_DIR"/*.gz 2>/dev/null || echo "No backup files found"
    echo "Please run backup.sh first."
    exit 1
fi

echo "Found backup files:"
echo "  Database: $DB_BACKUP_FILE ($(du -h "$DB_BACKUP_FILE" | cut -f1))"
if [ -f "$JOOMLA_BACKUP_FILE" ]; then
    echo "  Files: $JOOMLA_BACKUP_FILE ($(du -h "$JOOMLA_BACKUP_FILE" | cut -f1))"
fi

if ! docker ps | grep -q "$MYSQL_CONTAINER_NAME"; then
    echo "MySQL container not running. Starting environment..."
    ./setup.sh
    if [ $? -ne 0 ]; then
        echo "Error: Failed to start environment"
        exit 1
    fi
    echo "Waiting for MySQL to be ready..."
    sleep 30
fi

echo "Restoring MySQL database..."

echo "Preparing database for restore..."
docker exec "$MYSQL_CONTAINER_NAME" sh -c "exec mysqladmin -u$MYSQL_USER -p$MYSQL_ROOT_PASSWORD -f drop $MYSQL_DATABASE" 2>/dev/null
docker exec "$MYSQL_CONTAINER_NAME" sh -c "exec mysqladmin -u$MYSQL_USER -p$MYSQL_ROOT_PASSWORD create $MYSQL_DATABASE"

echo "Restoring database from backup..."
gunzip < "$DB_BACKUP_FILE" | docker exec -i "$MYSQL_CONTAINER_NAME" sh -c "exec mysql -h 127.0.0.1 -u$MYSQL_USER -p$MYSQL_ROOT_PASSWORD --force"

if [ $? -eq 0 ]; then
    echo "✓ Database restore completed successfully"
else
    echo "✗ Database restore failed!"
    exit 1
fi

if [ -f "$JOOMLA_BACKUP_FILE" ]; then
    echo "Restoring Joomla files..."

    docker exec -i "$JOOMLA_CONTAINER_NAME" sh -c "cd / && tar xzf -" < "$JOOMLA_BACKUP_FILE"

    if [ $? -eq 0 ]; then
        echo "✓ Joomla files restore completed successfully"
    else
        echo "✗ Joomla files restore failed!"
    fi
else
    echo "⚠ No Joomla files backup found, skipping file restore"
fi

echo "Restarting Joomla container..."
docker restart "$JOOMLA_CONTAINER_NAME"

echo "Waiting for services to be ready..."
sleep 20

echo "Verifying restore..."
if docker ps | grep -q "$MYSQL_CONTAINER_NAME" && docker ps | grep -q "$JOOMLA_CONTAINER_NAME"; then
    echo "✓ All containers are running"
else
    echo "⚠ Some containers may not be running properly"
fi

echo ""
echo "Restore process completed!"
echo ""
echo "Access your restored Joomla site:"
echo "  Main site: http://localhost:8080"
echo "  Admin panel: http://localhost:8080/administrator"
echo "  Admin login: demoadmin / secretpassword"
echo ""
echo "Check container status:"
echo "  docker ps"