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

echo "# ------------------------------------------------------------------------------------------------------------------------"
echo "# Orderer TLS certificate."
echo "# ------------------------------------------------------------------------------------------------------------------------"
set -x

scp

scp root@tlsca.fabric.com:/etc/hyperledger/fabric.com/tlsca-server/tlsca/tlsca.fabric.com-cert.pem /etc/hyperledger/orderers/tlsca/

export FABRIC_CA_CLIENT_TLS_CERTFILES=/etc/hyperledger/orderers/tlsca/tlsca.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/orderers/tlsca-admin
export FABRIC_CA_CLIENT_MSPDIR=/etc/hyperledger/orderers/orderer1.fabric.com/tls
fabric-ca-client enroll -d -u https://orderer1.fabric.com:ordererPW@tlsca.fabric.com:7150 --enrollment.profile tls --csr.hosts orderer1.fabric.com
sleep 2
tree /etc/hyperledger

export FABRIC_CA_CLIENT_MSPDIR=/etc/hyperledger/orderers/users/admin@fabric.com/tls
fabric-ca-client enroll -d -u https://admin@fabric.com:ordereradminpw@tlsca.fabric.com:7150 --enrollment.profile tls --csr.hosts orderer1.fabric.com
sleep 2
tree /etc/hyperledger

# rename keystore -sk= key.pem
#mkdir /etc/hyperledger/orderers/orderer1.fabric.com/msp/admincerts
cp /etc/hyperledger/orderers/users/admin@fabric.com/tls/keystore/*_sk /etc/hyperledger/orderers/users/admin@fabric.com/tls/keystore/key.pem

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
