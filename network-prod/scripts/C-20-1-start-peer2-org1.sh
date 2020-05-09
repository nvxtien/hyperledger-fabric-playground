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
cd $HOME

echo " ------------------------------------------------------------------------------------------------------ "
echo " Setup Org1's peer1"
echo " ------------------------------------------------------------------------------------------------------ "

echo " ------------------------------------------------------------------------------------------------------ "
echo " This operation happening on peer1-org1"
echo " ------------------------------------------------------------------------------------------------------ "
echo " You must do configuration as the following before issuing this script"
echo " - enable rca-org1 to be ssh with password"
echo " - enable rca-org1 to be scp without password"

set -x

cat > peer2-org1.service << EOF
# Service definition for Hyperledger Fabric peer
[Unit]
Description=hyperledger fabric-ca server - Certificate Authority for hyperledger fabric
Documentation=https://hyperledger-fabric-ca.readthedocs.io/
Wants=network-online.target
After=network-online.target
[Service]
Type=simple
Restart=on-failure
Environment=CORE_PEER_ID=peer2-org1
Environment=CORE_PEER_ADDRESS=peer2-org1:7051
Environment=CORE_PEER_LISTENADDRESS=0.0.0.0:7051
Environment=CORE_PEER_CHAINCODEADDRESS=peer2-org1:7052
Environment=CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:7052
Environment=CORE_PEER_LOCALMSPID=org1MSP
Environment=CORE_PEER_MSPCONFIGPATH=/tmp/hyperledger/org1/peer2/msp
Environment=CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
Environment=FABRIC_LOGGING_SPEC=grpc=debug:info
Environment=FABRIC_CFG_PATH=/tmp/hyperledger/config
Environment=CORE_PEER_TLS_ENABLED=true
Environment=CORE_PEER_TLS_CERT_FILE=/tmp/hyperledger/org1/peer2/tls-msp/signcerts/cert.pem
Environment=CORE_PEER_TLS_KEY_FILE=/tmp/hyperledger/org1/peer2/tls-msp/keystore/key.pem
Environment=CORE_PEER_TLS_ROOTCERT_FILE=/tmp/hyperledger/org1/peer2/tls-msp/tlscacerts/tls-tls-ca-7052.pem
Environment=CORE_PEER_GOSSIP_USELEADERELECTION=true
Environment=CORE_PEER_GOSSIP_ORGLEADER=false
Environment=CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer2-org1:7051
Environment=CORE_PEER_GOSSIP_SKIPHANDSHAKE=true
Environment=CORE_PEER_GOSSIP_BOOTSTRAP=peer1-org1:7051
ExecStart=/usr/local/bin/peer node start
[Install]
WantedBy=multi-user.target
EOF

sudo cp peer2-org1.service /etc/systemd/system/
sudo systemctl enable peer2-org1.service
sudo systemctl start peer2-org1.service
sleep 15
sudo systemctl status peer2-org1.service

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