#!/bin/bash


set -ev # If any comand fails throws an Error

export CHANNEL_NAME=energychannel
export IMAGE_TAG=2.2


docker-compose -f docker-compose.yaml down

docker-compose -f docker-compose.yaml up -d orderer.energy.com
