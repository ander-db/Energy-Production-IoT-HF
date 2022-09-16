#!/bin/bash

CC_NAME=sacc
CC_VERSION=1.0
CC_LABEL=sacc_1.0
CC_PACKAGE_TAR=sacc_1.0.tar.gz
CHANNEL_ID=testnetwork



declare -a clients_list=("cli" "cliOrg2")

for i in "${clients_list[@]}"
do
docker exec -i $i /bin/bash << EOF
cd /root
peer lifecycle chaincode package $CC_PACKAGE_TAR --path /opt/gopath/src/github.com/chaincode/javascript/ --lang node --label $CC_LABEL
peer lifecycle chaincode install $CC_PACKAGE_TAR
peer lifecycle chaincode queryinstalled 
export CC_PACKAGE_ID=\$(peer lifecycle chaincode queryinstalled | grep "$CC_LABEL" | cut -d ' ' -f3 | cut -d ',' -f1)
peer lifecycle chaincode approveformyorg -o orderer.example.com:7050 --tls --cafile \$ORDERER_TLS_CA --channelID $CHANNEL_ID --name $CC_NAME --version $CC_VERSION --package-id \$CC_PACKAGE_ID --sequence 1
exit
EOF
done

docker exec -i cliOrg2 /bin/bash << EOF
peer lifecycle chaincode commit -o orderer.example.com:7050 \
	--tls \
	--cafile \$ORDERER_TLS_CA \
	--channelID $CHANNEL_ID \
	--name $CC_NAME \
	--version $CC_VERSION \
	--sequence 1 \
	--peerAddresses \$CORE_PEER_ADDRESS --tlsRootCertFiles \$CORE_PEER_TLS_ROOTCERT_FILE \
	--peerAddresses peer0.org1.example.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
exit
EOF

docker exec -i cli /bin/bash << EOF
peer lifecycle chaincode querycommitted --channelID $CHANNEL_ID --name $CC_NAME
exit
EOF
