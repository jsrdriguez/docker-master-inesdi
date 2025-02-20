#!/usr/bin/env bash

# LOAD ENVIROMENT

if [ -f .env ]; then
  source .env
else 
  echo "Enviroment file not found"
  exit 1
fi

echo "[*] Creation network..."
if ! docker network create $NAME_NETWORK ; then
    echo "Failed creation network $1"
    return 1
fi

echo "[*] Docker container db up..."
if ! docker run -d --name $NAME_IMAGE_DB \
    -e MYSQL_ROOT_PASSWORD=$DB_PASSWORD \
    -e MYSQL_DATABASE=$DB_NAME \
    -p $DB_PORT_SHARED:$DB_PORT \
    -v $PWD/start.sql:/docker-entrypoint-initdb.d/start.sql \
    --network $NAME_NETWORK \
    --restart=always \
    mysql:9.2.0 ; then

    echo "Failed creation container db $1"

    return 1
fi

echo "[*] Build docker image..."
if ! docker build -t $NAME_IMAGE_DOCKER:$VERSION $PWD/app ; then
    echo "Failed creation container db $1"
    return 1
fi

echo "[*] Docker container web up..."
if ! docker run -d --name $NAME_IMAGE_APP \
    -e DB_HOST=$DB_HOST \
    -e DB_USERNAME=$DB_USERNAME \
    -e DB_PASSWORD=$DB_PASSWORD \
    -e DB_NAME=$DB_NAME \
    -e DB_PORT=$DB_PORT \
    -p $APP_PORT:3000 \
    --network $NAME_NETWORK \
    --restart=always \
    -v $PWD/storage/articles:/app/storage/articles \
    $NAME_IMAGE_DOCKER:$VERSION ; then

    echo "Failed creation container api $1"

    return 1
fi


