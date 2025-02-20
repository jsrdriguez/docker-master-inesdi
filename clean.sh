#!/usr/bin/env bash
if [ -f .env ]; then
  source .env
else 
  echo "Enviroment file not found"
  exit 1
fi

echo "[*] Delete containers: $NAME_IMAGE_DB $NAME_IMAGE_APP"
if ! docker rm $NAME_IMAGE_DB $NAME_IMAGE_APP -f ; then
    echo "Docker clean"
    return 2
fi

echo "[*] Delete images"
if ! docker image rm -f $(docker images | grep "inesdi/blog" | awk '{print $3}') -f ; then
    echo "Images clean"
    return 2
fi

echo "[*] Delete network"
if ! docker network rm $NAME_NETWORK -f ; then
    echo "Network clean"
    return 2
fi

echo "[*] Delete folders volumes"
if ! rm -rf $PWD/storage ; then
    echo "Volumes clean"
    return 2
fi





