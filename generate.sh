#!/bin/bash

# Set env vars
export FABRIC_CFG_PATH=${PWD}
export CHANNEL_NAME=energychannel

# Remove previous crypto material and config transactions
mkdir -p config
rm -fr config/*
rm -fr crypto-config/*

# Generate crypto materials
./bin/cryptogen generate --config=./crypto-config.yaml
if [ "$?" -ne 0 ]; then
  echo "Failed to generate crypto material..."
  exit 1
fi


