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

cat > peer1-po1.service << EOF
# Service definition for Hyperledger Fabric  peer
[Unit]
Description=hyperledger fabric-ca server - Certificate Authority for hyperledger fabric
Documentation=https://hyperledger-fabric-ca.readthedocs.io/
Wants=network-online.target
After=network-online.target
[Service]
Type=forking
Restart=on-failure
Environment=CORE_PEER_ID=peer1.po1.fabric.com
Environment=CORE_PEER_ADDRESS=peer1.po1.fabric.com:7053
Environment=CORE_PEER_LISTENADDRESS=0.0.0.0:7053
Environment=CORE_PEER_CHAINCODEADDRESS=peer1.po1.fabric.com:7054
Environment=CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:7054
Environment=CORE_PEER_LOCALMSPID=po1MSP
#Environment=CORE_PEER_PROFILE_ENABLED=true
Environment=CORE_PEER_TLS_ENABLED=true
Environment=CORE_PEER_TLS_CERT_FILE=/etc/hyperledger/po1.fabric.com/peers/peer1.po1.fabric.com/tls/signcerts/cert.pem
Environment=CORE_PEER_TLS_KEY_FILE=/etc/hyperledger/po1.fabric.com/peers/peer1.po1.fabric.com/tls/keystore/key.pem
Environment=CORE_PEER_TLS_ROOTCERT_FILE=/etc/hyperledger/po1.fabric.com/peers/peer1.po1.fabric.com/tls/tlscacerts/tls-tlsca-po1-fabric-com-7151.pem
Environment=CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/po1.fabric.com/peers/peer1.po1.fabric.com/msp
Environment=FABRIC_CFG_PATH=/etc/hyperledger/config
Environment=CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
Environment=FABRIC_LOGGING_SPEC=debug

Environment=CORE_PEER_GOSSIP_USELEADERELECTION=true
Environment=CORE_PEER_GOSSIP_ORGLEADER=false
Environment=CORE_PEER_GOSSIP_EXTERNALENDPOINT=peer1.po1.fabric.com:7053
Environment=CORE_PEER_GOSSIP_SKIPHANDSHAKE=true
Environment=CORE_PEER_GOSSIP_BOOTSTRAP=peer0.po1.fabric.com:7051

ExecStart=/usr/local/bin/peer node start
[Install]
WantedBy=multi-user.target
EOF

sudo cp peer1-po1.service /etc/systemd/system/
sudo systemctl enable peer1-po1.service
sudo systemctl start peer1-po1.service
#sleep 15
#sudo systemctl status peer1-po1.service

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
