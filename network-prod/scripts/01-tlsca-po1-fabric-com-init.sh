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

cat > tls-ca-init.service << EOF
# Service definition for Hyperledger fabric-ca server
[Unit]
Description=hyperledger fabric-ca server - Certificate Authority for hyperledger fabric
Documentation=https://hyperledger-fabric-ca.readthedocs.io/
Wants=network-online.target
After=network-online.target
[Service]
Type=simple
Restart=on-failure
Environment=FABRIC_CA_SERVER_HOME=/etc/hyperledger/fabric-ca
Environment=FABRIC_CA_SERVER_TLS_ENABLED=true
Environment=FABRIC_CA_SERVER_CA_NAME=tlsca.po1.fabric.com
Environment=FABRIC_CA_SERVER_CSR_CN=tlsca.po1.fabric.com
Environment=FABRIC_CA_SERVER_CSR_HOSTS=tlsca.po1.fabric.com
Environment=FABRIC_CA_SERVER_CA_KEYFILE=/etc/hyperledger/fabric-ca/tlsca/tlsca.po1.fabric.com-key.pem
Environment=FABRIC_CA_SERVER_CA_CERTFILE=/etc/hyperledger/fabric-ca/tlsca/tlsca.po1.fabric.com-cert.pem
Environment=FABRIC_CA_SERVER_DEBUG=true
ExecStart=/usr/local/bin/fabric-ca-server init -d -b tls-ord-admin:tls-ord-adminpw --port 7151 --cfg.identities.allowremove
[Install]
WantedBy=multi-user.target
EOF

sudo cp $HOME/tls-ca-init.service /etc/systemd/system/
sudo systemctl enable tls-ca-init.service
sudo systemctl start tls-ca-init.service
sleep 5
sudo systemctl status tls-ca-init.service

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo

echo " Completed Defining the network"
exit 0
