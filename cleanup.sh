#!/bin/bash

NETWORK_NAME="dev-tools-net"
MYSQL_IMAGE="mysql:latest"
MYSQL_CONTAINER_NAME="mysql-db"
JOOMLA_IMAGE="joomla:latest"
JOOMLA_CONTAINER_NAME="joomla-app"

echo "Starting cleanup process..."

echo "Stopping containers..."
docker stop "$MYSQL_CONTAINER_NAME" 2>/dev/null
docker stop "$JOOMLA_CONTAINER_NAME" 2>/dev/null

echo "Removing containers..."
docker rm "$MYSQL_CONTAINER_NAME" 2>/dev/null
docker rm "$JOOMLA_CONTAINER_NAME" 2>/dev/null

echo "Removing Docker images..."
docker rmi "$MYSQL_IMAGE" 2>/dev/null
docker rmi "$JOOMLA_IMAGE" 2>/dev/null

echo "Removing network..."
docker network rm "$NETWORK_NAME" 2>/dev/null

echo "Removing volumes..."
docker volume prune -f

echo "Cleaning up unused Docker resources..."
docker system prune -f

echo "Cleanup completed!"
echo "All Joomla project resources have been removed."