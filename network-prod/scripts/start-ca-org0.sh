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
echo " Get binaries "
echo " ------------------------------------------------------------------------------------------------------ "
curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.0.1 1.4.6 0.4.18

echo " ------------------------------------------------------------------------------------------------------ "
echo " Create CA service for Org0"
echo " ------------------------------------------------------------------------------------------------------ "
pwd
cp ./fabric-samples/bin/fabric-samples/bin/* /usr/local/bin/

cat > rca-org0.service << EOF
# Service definition for Hyperledger fabric-ca server
[Unit]
Description=hyperledger fabric-ca server - Certificate Authority for hyperledger fabric
Documentation=https://hyperledger-fabric-ca.readthedocs.io/
Wants=network-online.target
After=network-online.target
[Service]
Type=simple
Restart=on-failure
Environment=FABRIC_CA_SERVER_DEBUG=true
Environment=FABRIC_CA_SERVER_HOME=/tmp/hyperledger/fabric-ca/crypto
Environment=FABRIC_CA_SERVER_TLS_ENABLED=true
Environment=FABRIC_CA_SERVER_CSR_CN=rca-org0
Environment=FABRIC_CA_SERVER_CSR_HOSTS=rca-org0
ExecStart=/usr/local/bin/fabric-ca-server start -d -b rca-org0-admin:rca-org0-adminpw --port 7053
[Install]
WantedBy=multi-user.target
EOF

sudo cp rca-org0.service /etc/systemd/system/
sudo systemctl enable rca-org0.service
sudo systemctl start rca-org0.service
sleep 5
sudo systemctl status tls-ca.service

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo

echo " Completed Defining the network"
exit 0
