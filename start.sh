#!/bin/bash


set -ev # If any comand fails throws an Error

export CHANNEL_NAME=energychannel
export IMAGE_TAG=2.2


docker-compose -f docker-compose.yaml down

docker-compose -f docker-compose.yaml up -d orderer.energy.com \
                                          couchdbRenewableEnergyPeer0 \
                                          peer0.renewable.energy.com \
                                          ca.renewable.energy.com \
                                          couchdbRenewableEnergyPeer1 \
                                          peer1.renewable.energy.com \
                                          ca.renewable.energy.com \
                                          cliRenewable


# Wait for Hyperledger Fabric to start
# In case of errors when running later commands, issue export FABRIC_START_TIMEOUT=<larger number>
export FABRIC_START_TIMEOUT=10
sleep ${FABRIC_START_TIMEOUT}

# Create the application channel
ORDERER_TLS_CA=`docker exec cliRenewable  env | grep ORDERER_TLS_CA | cut -d'=' -f2`
docker exec cliRenewable peer channel create -o orderer.energy.com:7050 -c $CHANNEL_NAME -f /etc/hyperledger/configtx/$CHANNEL_NAME.tx --tls --cafile $ORDERER_TLS_CA

# RenewableEnergy Peers
# Join peer0.renewable.energy.com to the channel
docker exec cliRenewable peer channel join -b $CHANNEL_NAME.block

# Join peer1.renewable.energy.com to the channel
docker exec -e CORE_PEER_ADDRESS=peer1.renewable.energy.com:7051 \
  -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/renewable.energy.com/peers/peer1.renewable.energy.com/tls/server.crt \
  -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/renewable.energy.com/peers/peer1.renewable.energy.com/tls/server.key \
  -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/renewable.energy.com/peers/peer1.renewable.energy.com/tls/ca.crt \
  cliRenewable peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.energy.com:7050 --tls --cafile $ORDERER_TLS_CA

docker exec -e CORE_PEER_ADDRESS=peer1.renewable.energy.com:7051\
  -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/renewable.energy.com/peers/peer1.renewable.energy.com/tls/server.crt \
  -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/renewable.energy.com/peers/peer1.renewable.energy.com/tls/server.key \
  -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/renewable.energy.com/peers/peer1.renewable.energy.com/tls/ca.crt \
  cliRenewable peer channel join -b $CHANNEL_NAME.block
