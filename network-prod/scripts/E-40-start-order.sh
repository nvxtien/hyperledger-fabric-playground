#!/bin/sh
echo
echo " ____    _____      _      ____    _____ "
echo "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echo "\___ \    | |     / _ \   | |_) |   | |  "
echo " ___) |   | |    / ___ \  |  _ <    | |  "
echo "|____/    |_|   /_/   \_\ |_| \_\   |_|  "
echo
echo "Define by Tien"
echo
set -x

cat > orderer1-org0.service << EOF
# Service definition for Hyperledger Fabric  peer
[Unit]
Description=hyperledger fabric-ca server - Certificate Authority for hyperledger fabric
Documentation=https://hyperledger-fabric-ca.readthedocs.io/
Wants=network-online.target
After=network-online.target
[Service]
Type=forking
Restart=on-failure
Environment=FABRIC_CFG_PATH=/tmp/hyperledger/config
Environment=ORDERER_HOME=/tmp/hyperledger/orderer
Environment=ORDERER_HOST=orderer1-org0
Environment=ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
Environment=ORDERER_GENERAL_GENESISMETHOD=file
Environment=ORDERER_GENERAL_GENESISFILE=/tmp/hyperledger/org0/orderer/genesis.block
Environment=ORDERER_GENERAL_LOCALMSPID=org0MSP
Environment=ORDERER_GENERAL_LOCALMSPDIR=/tmp/hyperledger/org0/orderer/msp
Environment=ORDERER_GENERAL_TLS_ENABLED=true
Environment=ORDERER_GENERAL_TLS_CERTIFICATE=/tmp/hyperledger/org0/orderer/tls-msp/signcerts/cert.pem
Environment=ORDERER_GENERAL_TLS_PRIVATEKEY=/tmp/hyperledger/org0/orderer/tls-msp/keystore/key.pem
Environment=ORDERER_GENERAL_TLS_ROOTCAS=[/tmp/hyperledger/org0/orderer/tls-msp/tlscacerts/tls-tls-ca-7052.pem]
Environment=ORDERER_GENERAL_LOGLEVEL=debug
Environment=ORDERER_DEBUG_BROADCASTTRACEDIR=data/logs
ExecStart=/usr/local/bin/orderer
[Install]
WantedBy=multi-user.target
EOF

sudo cp orderer1-org0.service /etc/systemd/system/
sudo systemctl enable orderer1-org0.service
sudo systemctl start orderer1-org0.service
sleep 15
sudo systemctl status orderer1-org0.service

set +x

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo

echo " Completed Defining the network"
exit 0
