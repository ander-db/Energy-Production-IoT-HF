#!/bin/bash

set -e


docker-compose -f docker-compose.yaml kill && docker-compose -f docker-compose.yaml down --volumes --remove-orphans


# Remove chaincode Docker container and images
CONTAINER_IDS=$(docker ps -a | awk '($2 ~ /dev-peer.*/) {print $1}')
if [ -z "$CONTAINER_IDS" -o "$CONTAINER_IDS" == " " ]; then
    echo "No containers available for deletion."
else
    docker rm -f $CONTAINER_IDS
fi

DOCKER_IMAGE_IDS=$(docker images | awk '($1 ~ /dev-peer.*/) {print $3}')
if [ -z "$DOCKER_IMAGE_IDS" -o "$DOCKER_IMAGE_IDS" == " " ]; then
    echo "No images available for deletion."
else
    docker rmi -f $DOCKER_IMAGE_IDS
fi

# Your system is now clean


