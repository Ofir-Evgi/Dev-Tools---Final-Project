NETWORK_NAME="dev-tools-net"

MYSQL_IMAGE="mysql:latest"
MYSQL_CONTAINER_NAME="mysql-db"
MYSQL_ROOT_PASSWORD="my-secret-pw"
MYSQL_DATABASE="our-app-db"

JOOMLA_IMAGE="joomla:latest"
JOOMLA_CONTAINER_NAME="joomla-app"
JOOMLA_USER="root"

echo "Creating docker network"
docker network create "$NETWORK_NAME"

docker pull "$MYSQL_IMAGE"
docker pull "$JOOMLA_IMAGE"

docker run -d \
  --name "$MYSQL_CONTAINER_NAME" \
  --network "$NETWORK_NAME" \
  -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" \
  -e MYSQL_DATABASE="$MYSQL_DATABASE" \
  -p "$MYSQL_PORT:3306" \
  "$MYSQL_IMAGE"

docker run -d \
  --name "$JOOMLA_CONTAINER_NAME" \
  --network "$NETWORK_NAME" \
  -e JOOMLA_DB_HOST="$MYSQL_CONTAINER_NAME" \
  -e JOOMLA_DB_USER="$JOOMLA_USER" \
  -e JOOMLA_DB_PASSWORD="$MYSQL_ROOT_PASSWORD" \
  -e JOOMLA_DB_NAME="$MYSQL_DATABASE" \
  -p "8080:80" \
  "$JOOMLA_IMAGE"