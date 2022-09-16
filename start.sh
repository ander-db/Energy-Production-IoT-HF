#!/bin/bash


set -ev # If any comand fails throws an Error

export CHANNEL_NAME=energychannel


docker-compose -f docker-compose.yaml down

docker-compose -f docker-compose.yaml up -d orderer.energy.com \
                                          ca.renewable.energy.com \
                                          couchdbRenewableEnergyPeer0 \
                                          peer0.renewable.energy.com \
                                          couchdbRenewableEnergyPeer1 \
                                          peer1.renewable.energy.com \
                                          ca.nonrenewable.energy.com \
                                          couchdbNonRenewableEnergyPeer0 \
                                          peer0.nonrenewable.energy.com \
                                          couchdbNonRenewableEnergyPeer1 \
                                          peer1.nonrenewable.energy.com \
                                          ca.electricnetwork.energy.com \
                                          couchdbElectricNetworkPeer0 \
                                          peer0.electricnetwork.energy.com \
                                          couchdbElectricNetworkPeer1 \
                                          peer1.electricnetwork.energy.com \
                                          ca.distributor1.energy.com \
                                          couchdbDistributor1Peer0 \
                                          peer0.distributor1.energy.com \
                                          couchdbDistributor1Peer1 \
                                          peer1.distributor1.energy.com \
                                          ca.distributor2.energy.com \
                                          couchdbDistributor2Peer0 \
                                          peer0.distributor2.energy.com \
                                          couchdbDistributor2Peer1 \
                                          peer1.distributor2.energy.com \
                                          ca.regulator.energy.com \
                                          couchdbRegulatorPeer0 \
                                          peer0.regulator.energy.com \
                                          couchdbRegulatorPeer1 \
                                          peer1.regulator.energy.com \
                                          cliRenewable \
                                          cliNonRenewable \
                                          cliElectricNetwork \
                                          cliDistributor1 \
                                          cliDistributor2 \
                                          cliRegulator


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


# NonRenewableEnergy Peers
# Join peer0.nonrenewable.energy.com to the channel
docker exec cliNonRenewable peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.energy.com:7050 --tls --cafile $ORDERER_TLS_CA
docker exec cliNonRenewable peer channel join -b $CHANNEL_NAME.block

# Join peer1.nonrenewable.energy.com to the channel
docker exec -e CORE_PEER_ADDRESS=peer1.nonrenewable.energy.com:7051 \
  -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/nonrenewable.energy.com/peers/peer1.nonrenewable.energy.com/tls/server.crt \
  -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/nonrenewable.energy.com/peers/peer1.nonrenewable.energy.com/tls/server.key \
  -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/nonrenewable.energy.com/peers/peer1.nonrenewable.energy.com/tls/ca.crt \
  cliNonRenewable peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.energy.com:7050 --tls --cafile $ORDERER_TLS_CA

docker exec -e CORE_PEER_ADDRESS=peer1.nonrenewable.energy.com:7051\
  -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/nonrenewable.energy.com/peers/peer1.nonrenewable.energy.com/tls/server.crt \
  -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/nonrenewable.energy.com/peers/peer1.nonrenewable.energy.com/tls/server.key \
  -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/nonrenewable.energy.com/peers/peer1.nonrenewable.energy.com/tls/ca.crt \
  cliNonRenewable peer channel join -b $CHANNEL_NAME.block


# ElectricNetwork Peers
# Join peer0.electricnetwork.energy.com to the channel
docker exec cliElectricNetwork peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.energy.com:7050 --tls --cafile $ORDERER_TLS_CA
docker exec cliElectricNetwork peer channel join -b $CHANNEL_NAME.block

# Join peer1.electricnetwork.energy.com to the channel
docker exec -e CORE_PEER_ADDRESS=peer1.electricnetwork.energy.com:7051 \
  -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/electricnetwork.energy.com/peers/peer1.electricnetwork.energy.com/tls/server.crt \
  -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/electricnetwork.energy.com/peers/peer1.electricnetwork.energy.com/tls/server.key \
  -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/electricnetwork.energy.com/peers/peer1.electricnetwork.energy.com/tls/ca.crt \
  cliElectricNetwork peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.energy.com:7050 --tls --cafile $ORDERER_TLS_CA

docker exec -e CORE_PEER_ADDRESS=peer1.electricnetwork.energy.com:7051\
  -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/electricnetwork.energy.com/peers/peer1.electricnetwork.energy.com/tls/server.crt \
  -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/electricnetwork.energy.com/peers/peer1.electricnetwork.energy.com/tls/server.key \
  -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/electricnetwork.energy.com/peers/peer1.electricnetwork.energy.com/tls/ca.crt \
  cliElectricNetwork peer channel join -b $CHANNEL_NAME.block




# Distributor1 Peers
# Join peer0.distributor1.energy.com to the channel
docker exec cliDistributor1 peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.energy.com:7050 --tls --cafile $ORDERER_TLS_CA
docker exec cliDistributor1 peer channel join -b $CHANNEL_NAME.block

# Join peer1.distributor1.energy.com to the channel
docker exec -e CORE_PEER_ADDRESS=peer1.distributor1.energy.com:7051 \
  -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor1.energy.com/peers/peer1.distributor1.energy.com/tls/server.crt \
  -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor1.energy.com/peers/peer1.distributor1.energy.com/tls/server.key \
  -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor1.energy.com/peers/peer1.distributor1.energy.com/tls/ca.crt \
  cliDistributor1 peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.energy.com:7050 --tls --cafile $ORDERER_TLS_CA

docker exec -e CORE_PEER_ADDRESS=peer1.distributor1.energy.com:7051\
  -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor1.energy.com/peers/peer1.distributor1.energy.com/tls/server.crt \
  -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor1.energy.com/peers/peer1.distributor1.energy.com/tls/server.key \
  -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor1.energy.com/peers/peer1.distributor1.energy.com/tls/ca.crt \
  cliDistributor1 peer channel join -b $CHANNEL_NAME.block


# Distributor2 Peers
# Join peer0.distributor2.energy.com to the channel
docker exec cliDistributor2 peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.energy.com:7050 --tls --cafile $ORDERER_TLS_CA
docker exec cliDistributor2 peer channel join -b $CHANNEL_NAME.block

# Join peer1.distributor2.energy.com to the channel
docker exec -e CORE_PEER_ADDRESS=peer1.distributor2.energy.com:7051 \
  -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor2.energy.com/peers/peer1.distributor2.energy.com/tls/server.crt \
  -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor2.energy.com/peers/peer1.distributor2.energy.com/tls/server.key \
  -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor2.energy.com/peers/peer1.distributor2.energy.com/tls/ca.crt \
  cliDistributor2 peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.energy.com:7050 --tls --cafile $ORDERER_TLS_CA

docker exec -e CORE_PEER_ADDRESS=peer1.distributor2.energy.com:7051\
  -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor2.energy.com/peers/peer1.distributor2.energy.com/tls/server.crt \
  -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor2.energy.com/peers/peer1.distributor2.energy.com/tls/server.key \
  -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor2.energy.com/peers/peer1.distributor2.energy.com/tls/ca.crt \
  cliDistributor2 peer channel join -b $CHANNEL_NAME.block



# Regulator Peers
# Join peer0.regulator.energy.com to the channel
docker exec cliRegulator peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.energy.com:7050 --tls --cafile $ORDERER_TLS_CA
docker exec cliRegulator peer channel join -b $CHANNEL_NAME.block

# Join peer1.regulator.energy.com to the channel
docker exec -e CORE_PEER_ADDRESS=peer1.regulator.energy.com:7051 \
  -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/regulator.energy.com/peers/peer1.regulator.energy.com/tls/server.crt \
  -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/regulator.energy.com/peers/peer1.regulator.energy.com/tls/server.key \
  -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/regulator.energy.com/peers/peer1.regulator.energy.com/tls/ca.crt \
  cliRegulator peer channel fetch oldest $CHANNEL_NAME.block -c $CHANNEL_NAME --orderer orderer.energy.com:7050 --tls --cafile $ORDERER_TLS_CA

docker exec -e CORE_PEER_ADDRESS=peer1.regulator.energy.com:7051\
  -e CORE_PEER_TLS_CERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/regulator.energy.com/peers/peer1.regulator.energy.com/tls/server.crt \
  -e CORE_PEER_TLS_KEY_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/regulator.energy.com/peers/peer1.regulator.energy.com/tls/server.key \
  -e CORE_PEER_TLS_ROOTCERT_FILE=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/regulator.energy.com/peers/peer1.regulator.energy.com/tls/ca.crt \
  cliRegulator peer channel join -b $CHANNEL_NAME.block


