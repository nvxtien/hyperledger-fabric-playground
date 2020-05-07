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
#curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.0.1 1.4.6 0.4.18

echo " ------------------------------------------------------------------------------------------------------ "
echo " Create CA service for Org1"
echo " ------------------------------------------------------------------------------------------------------ "
pwd
cp $HOME/fabric-samples/bin/* /usr/local/bin/

cat > rca-org1.service << EOF
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
Environment=FABRIC_CA_SERVER_CSR_CN=rca-org1
Environment=FABRIC_CA_SERVER_CSR_HOSTS=rca-org1
ExecStart=/usr/local/bin/fabric-ca-server start -d -b rca-org1-admin:rca-org1-adminpw --port 7054
[Install]
WantedBy=multi-user.target
EOF

sudo cp rca-org1.service /etc/systemd/system/
sudo systemctl enable rca-org1.service
sudo systemctl start rca-org1.service
sleep 5
sudo systemctl status rca-org1.service

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo

echo " Completed Defining the network"
exit 0
