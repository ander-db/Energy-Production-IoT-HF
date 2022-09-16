CC_NAME=production
CC_VERSION=1.0
CC_LABEL=production_1.0
CC_PACKAGE_TAR=production.tar.gz
CHANNEL_ID=energychannel


docker exec -i cliRenewable /bin/bash << EOF 
peer chaincode invoke \
  -o orderer.energy.com:7050 \
  --tls --cafile \$ORDERER_TLS_CA \
  -C $CHANNEL_ID \
  -n $CC_NAME \
  --peerAddresses \$CORE_PEER_ADDRESS \
  --tlsRootCertFiles \$CORE_PEER_TLS_ROOTCERT_FILE \
  --isInit \
  --waitForEvent -c '{"function":"InitLedger", "args":[]}' \
  --peerAddresses peer0.nonrenewable.energy.com:7051 --tlsRootCertFiles /opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/nonrenewable.energy.com/peers/peer0.nonrenewable.energy.com/tls/ca.crt \
exit
EOF


