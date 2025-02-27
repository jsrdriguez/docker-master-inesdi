#!/usr/bin/env bash
if [ -f .env ]; then
  source .env
else 
  echo "Enviroment file not found"
  exit 1
fi

echo "[*] Container services down"
if ! docker-compose down --remove-orphans --rmi local --volumes; then
    echo "Docker clean"
    return 2
fi

echo "[*] Delete network"
if ! docker network rm $NAME_NETWORK -f ; then
    echo "Network clean"
    return 2
fi

echo "[*] Delete folders volumes"
if ! rm -rf $PWD/volume* ; then
    echo "Volumes clean"
    return 2
fi





