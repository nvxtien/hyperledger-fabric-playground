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
echo " Create TLS CA service "
echo " ------------------------------------------------------------------------------------------------------ "

cat > tlsca-init.service << EOF
# Service definition for Hyperledger fabric-ca server
[Unit]
Description=hyperledger fabric-ca server - Certificate Authority for hyperledger fabric
Documentation=https://hyperledger-fabric-ca.readthedocs.io/
Wants=network-online.target
After=network-online.target
[Service]
Type=simple
Restart=on-failure
Environment=FABRIC_CA_SERVER_HOME=/etc/hyperledger/fabric.com/tlsca-server
Environment=FABRIC_CA_SERVER_TLS_ENABLED=true
Environment=FABRIC_CA_SERVER_CA_NAME=tlsca.fabric.com
Environment=FABRIC_CA_SERVER_CSR_CN=tlsca.fabric.com
Environment=FABRIC_CA_SERVER_CSR_HOSTS=tlsca.fabric.com
Environment=FABRIC_CA_SERVER_CA_KEYFILE=/etc/hyperledger/fabric.com/tlsca-server/tlsca/tlsca.fabric.com-key.pem
Environment=FABRIC_CA_SERVER_CA_CERTFILE=/etc/hyperledger/fabric.com/tlsca-server/tlsca/tlsca.fabric.com-cert.pem
Environment=FABRIC_CA_SERVER_DEBUG=true
ExecStart=/usr/local/bin/fabric-ca-server init -d -b tls-ord-admin:tls-ord-adminpw --port 7150 --cfg.identities.allowremove
[Install]
WantedBy=multi-user.target
EOF

sudo cp $HOME/tlsca-init.service /etc/systemd/system/
sudo systemctl enable tlsca-init.service
sudo systemctl start tlsca-init.service
sleep 5
sudo systemctl status tlsca-init.service

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
