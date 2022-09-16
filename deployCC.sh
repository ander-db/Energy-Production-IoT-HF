#!/bin/bash

CC_NAME=production
CC_VERSION=1.0
CC_LABEL=production_1.0
CC_PACKAGE_TAR=production.tar.gz
CHANNEL_ID=energychannel

declare -a clients_list=("cliRenewable" "cliNonRenewable" "cliElectricNetwork" "cliRegulator" "cliDistributor1" "cliDistributor2")

for i in "${clients_list[@]}"
do
docker exec -i $i /bin/bash << EOF
cd /root
peer lifecycle chaincode package $CC_PACKAGE_TAR --path /opt/gopath/src/github.com/chaincode/javascript/ --lang node --label $CC_LABEL
peer lifecycle chaincode install $CC_PACKAGE_TAR
peer lifecycle chaincode queryinstalled 
export CC_PACKAGE_ID=\$(peer lifecycle chaincode queryinstalled | grep "$CC_LABEL" | cut -d ' ' -f3 | cut -d ',' -f1)
peer lifecycle chaincode approveformyorg -o orderer.energy.com:7050 --tls --cafile \$ORDERER_TLS_CA --channelID $CHANNEL_ID --name $CC_NAME --version $CC_VERSION --package-id \$CC_PACKAGE_ID --sequence 1 --init-required --signature-policy "OR('RenewableEnergyMSP.peer', 'NonRenewableEnergyMSP.peer')"
exit
EOF
done

# Installing chaincode on peer1.*
for i in "${clients_list[@]}"
do
docker exec -i $i /bin/bash << EOF
export CORE_PEER_ADDRESS=\$(echo \$CORE_PEER_ADDRESS | sed "s/peer0/peer1/g")
export CORE_PEER_TLS_CERT_FILE=\$(echo \$CORE_PEER_TLS_CERT_FILE | sed "s/peer0/peer1/g")
export CORE_PEER_TLS_KEY_FILE=\$(echo \$CORE_PEER_TLS_KEY_FILE | sed "s/peer0/peer1/g")
export CORE_PEER_TLS_ROOTCERT_FILE=\$(echo \$CORE_PEER_TLS_ROOTCERT_FILE | sed "s/peer0/peer1/g")
export CORE_PEER_TLS_MSPCONFIGPATH=\$(echo \$CORE_PEER_TLS_MSPCONFIGPATH | sed "s/peer0/peer1/g")
peer lifecycle chaincode queryinstalled 

cd /root
peer lifecycle chaincode package $CC_PACKAGE_TAR --path /opt/gopath/src/github.com/chaincode/javascript/ --lang node --label $CC_LABEL
peer lifecycle chaincode install $CC_PACKAGE_TAR
peer lifecycle chaincode queryinstalled 
exit
EOF
done

docker exec -i cliRenewable peer lifecycle chaincode checkcommitreadiness --channelID $CHANNEL_ID --name $CC_NAME --version $CC_VERSION --sequence 1 --init-required --signature-policy "OR('RenewableEnergyMSP.peer', 'NonRenewableEnergyMSP.peer')" --output json


docker exec -i cliRenewable /bin/bash << EOF
peer lifecycle chaincode commit -o orderer.energy.com:7050 \
	--tls \
	--cafile \$ORDERER_TLS_CA \
	--channelID $CHANNEL_ID \
	--name $CC_NAME \
	--version $CC_VERSION \
	--sequence 1 \
	--init-required --signature-policy "OR('RenewableEnergyMSP.peer', 'NonRenewableEnergyMSP.peer')" \
	--peerAddresses peer0.renewable.energy.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/renewable.energy.com/peers/peer0.renewable.energy.com/tls/ca.crt \
	--peerAddresses peer0.nonrenewable.energy.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/nonrenewable.energy.com/peers/peer0.nonrenewable.energy.com/tls/ca.crt \
	--peerAddresses peer0.electricnetwork.energy.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/electricnetwork.energy.com/peers/peer0.electricnetwork.energy.com/tls/ca.crt \
	--peerAddresses peer0.distributor1.energy.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor1.energy.com/peers/peer0.distributor1.energy.com/tls/ca.crt \
	--peerAddresses peer0.distributor2.energy.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/distributor2.energy.com/peers/peer0.distributor2.energy.com/tls/ca.crt \
	--peerAddresses peer0.regulator.energy.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/regulator.energy.com/peers/peer0.regulator.energy.com/tls/ca.crt 

exit
EOF
