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
echo " Create CA service "
echo " ------------------------------------------------------------------------------------------------------ "

cat > ca-init.service << EOF
# Service definition for Hyperledger fabric-ca server
[Unit]
Description=hyperledger fabric-ca server - Certificate Authority for hyperledger fabric
Documentation=https://hyperledger-fabric-ca.readthedocs.io/
Wants=network-online.target
After=network-online.target
[Service]
Type=simple
Restart=on-failure
Environment=FABRIC_CA_SERVER_HOME=/etc/hyperledger/fabric.com/ca-server
Environment=FABRIC_CA_SERVER_TLS_ENABLED=true
Environment=FABRIC_CA_SERVER_CA_NAME=ca.fabric.com
Environment=FABRIC_CA_SERVER_CSR_CN=ca.fabric.com
Environment=FABRIC_CA_SERVER_CSR_HOSTS=ca.fabric.com
Environment=FABRIC_CA_SERVER_CA_KEYFILE=/etc/hyperledger/fabric.com/ca-server/ca/ca.fabric.com-key.pem
Environment=FABRIC_CA_SERVER_CA_CERTFILE=/etc/hyperledger/fabric.com/ca-server/ca/ca.fabric.com-cert.pem
Environment=FABRIC_CA_SERVER_DEBUG=true
ExecStart=/usr/local/bin/fabric-ca-server init -d -b rca-orderer-admin:rca-orderer-adminpw --port 7152 --cfg.identities.allowremove
[Install]
WantedBy=multi-user.target
EOF

sudo cp $HOME/ca-init.service /etc/systemd/system/
sudo systemctl enable ca-init.service
sudo systemctl start ca-init.service
sleep 5
sudo systemctl status ca-init.service

set -x
#cp /etc/hyperledger/fabric-ca/msp/keystore/*_sk /etc/hyperledger/fabric-ca/tlsca
#mkdir -p /etc/hyperledger/{ca-admin,tlsca-admin,tlsca-server}
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
