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

# Generate genesis block for orderer
./bin/configtxgen -profile OrdererGenesis -channelID system-channel -outputBlock ./config/genesis.block
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi


# Generate channel creation transaction
./bin/configtxgen -profile EnergyChannel -outputCreateChannelTx ./config/$CHANNEL_NAME.tx -channelID $CHANNEL_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate channel creation transaction..."
  exit 1
fi

##########

# Generate anchor peer transaction for RenewableEnergy
./bin/configtxgen -profile EnergyChannel -outputAnchorPeersUpdate ./config/RenewableEnergyAnchors.tx -channelID $CHANNEL_NAME -asOrg RenewableEnergyMSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for RenewableEnergyMSP..."
  exit 1
fi


# Generate anchor peer transaction for NonRenewableEnergy
./bin/configtxgen -profile EnergyChannel -outputAnchorPeersUpdate ./config/NonRenewableEnergyAnchors.tx -channelID $CHANNEL_NAME -asOrg NonRenewableEnergyMSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for NonRenewableEnergyMSP..."
  exit 1
fi


# Generate anchor peer transaction for ElectricNetwork
./bin/configtxgen -profile EnergyChannel -outputAnchorPeersUpdate ./config/ElectricNetworkAnchors.tx -channelID $CHANNEL_NAME -asOrg ElectricNetworkMSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for ElectricNetworkMSP..."
  exit 1
fi

# Generate anchor peer transaction for Distributor1
./bin/configtxgen -profile EnergyChannel -outputAnchorPeersUpdate ./config/Distributor1Anchors.tx -channelID $CHANNEL_NAME -asOrg Distributor1MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Distributor1MSP..."
  exit 1
fi


# Generate anchor peer transaction for Distributor2
./bin/configtxgen -profile EnergyChannel -outputAnchorPeersUpdate ./config/Distributor2Anchors.tx -channelID $CHANNEL_NAME -asOrg Distributor2MSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for Distributor2MSP..."
  exit 1
fi
 

# Generate anchor peer transaction for Regulator
./bin/configtxgen -profile EnergyChannel -outputAnchorPeersUpdate ./config/RegulatorAnchors.tx -channelID $CHANNEL_NAME -asOrg RegulatorMSP
if [ "$?" -ne 0 ]; then
  echo "Failed to generate anchor peer update for RegulatorMSP..."
  exit 1
fi
