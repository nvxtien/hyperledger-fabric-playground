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

cat > orderer.service << EOF
# Service definition for Hyperledger Fabric  peer
[Unit]
Description=hyperledger fabric-ca server - Certificate Authority for hyperledger fabric
Documentation=https://hyperledger-fabric-ca.readthedocs.io/
Wants=network-online.target
After=network-online.target
[Service]
Type=forking
Restart=on-failure
Environment=FABRIC_CFG_PATH=/etc/hyperledger/config

#Environment=ORDERER_HOME=/tmp/hyperledger/orderer

Environment=ORDERER_HOST=orderer1.fabric.com
Environment=ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
Environment=ORDERER_GENERAL_GENESISMETHOD=file
Environment=ORDERER_GENERAL_GENESISFILE=/etc/hyperledger/orderer/genesis.block
Environment=ORDERER_GENERAL_LOCALMSPID=org0MSP
Environment=ORDERER_GENERAL_LOCALMSPDIR=/etc/hyperledger/orderer/msp
Environment=ORDERER_GENERAL_TLS_ENABLED=true
Environment=ORDERER_GENERAL_TLS_CERTIFICATE=/etc/hyperledger/orderer/tls-msp/signcerts/cert.pem
Environment=ORDERER_GENERAL_TLS_PRIVATEKEY=/etc/hyperledger/orderer/tls-msp/keystore/key.pem
Environment=ORDERER_GENERAL_TLS_ROOTCAS=[/etc/hyperledger/orderer/tls-msp/tlscacerts/tls-tlsca-fabric-com-7150.pem]
Environment=FABRIC_LOGGING_SPEC=DEBUG
Environment=ORDERER_GENERAL_LOGLEVEL=DEBUG
Environment=ORDERER_DEBUG_BROADCASTTRACEDIR=data/logs
ExecStart=/usr/local/bin/orderer
[Install]
WantedBy=multi-user.target
EOF

sudo cp orderer.service /etc/systemd/system/
sudo systemctl enable orderer.service
sudo systemctl start orderer.service
sleep 15
sudo systemctl status orderer.service

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
