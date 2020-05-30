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

cat > tlsca-start.service << EOF
# Service definition for Hyperledger fabric-ca server
[Unit]
Description=hyperledger fabric-ca server - Certificate Authority for hyperledger fabric
Documentation=https://hyperledger-fabric-ca.readthedocs.io/
Wants=network-online.target
After=network-online.target
[Service]
Type=simple
Restart=on-failure
Environment=FABRIC_CA_SERVER_HOME=/etc/hyperledger/po1.fabric.com/tlsca-server
Environment=FABRIC_CA_SERVER_TLS_ENABLED=true
Environment=FABRIC_CA_SERVER_CA_NAME=tlsca.po1.fabric.com
Environment=FABRIC_CA_SERVER_CSR_CN=tlsca.po1.fabric.com
Environment=FABRIC_CA_SERVER_CSR_HOSTS=tlsca.po1.fabric.com
Environment=FABRIC_CA_SERVER_CA_KEYFILE=/etc/hyperledger/po1.fabric.com/tlsca-server/tlsca/tlsca.po1.fabric.com-key.pem
Environment=FABRIC_CA_SERVER_CA_CERTFILE=/etc/hyperledger/po1.fabric.com/tlsca-server/tlsca/tlsca.po1.fabric.com-cert.pem
Environment=FABRIC_CA_SERVER_DEBUG=true
ExecStart=/usr/local/bin/fabric-ca-server start -d -b tls-peer-admin:tls-peer-adminpw --port 7151 --cfg.identities.allowremove
[Install]
WantedBy=multi-user.target
EOF

sudo cp $HOME/tlsca-start.service /etc/systemd/system/
sudo systemctl enable tlsca-start.service
sudo systemctl start tlsca-start.service
sleep 5
sudo systemctl status tlsca-start.service

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo

echo " Completed Defining the network"
exit 0
