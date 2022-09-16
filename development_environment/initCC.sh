#!/bin/bash


CC_NAME=sacc
CHANNEL_NAME=testnetwork


docker exec -i cliOrg2 /bin/bash << EOF
peer chaincode invoke -o orderer.example.com:7050 \
	--tls \
	--cafile \$ORDERER_TLS_CA \
	-C $CHANNEL_NAME \
	-n $CC_NAME \
	--peerAddresses \$CORE_PEER_ADDRESS \
	--tlsRootCertFiles \$CORE_PEER_TLS_ROOTCERT_FILE \
	--peerAddresses peer0.org1.example.com:7051 \
	--tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt \
	-c '{"function":"InitLedger", "args":[]}' \
	--waitForEvent
exit
EOF

