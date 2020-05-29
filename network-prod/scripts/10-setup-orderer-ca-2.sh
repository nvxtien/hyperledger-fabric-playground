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

echo "# ------------------------------------------------------------------------------------------------------------------------"
echo "# Setup Orderer CA"
echo "# ------------------------------------------------------------------------------------------------------------------------"
# Alternate Method manual copy

export FABRIC_CA_CLIENT_TLS_CERTFILES=/etc/hyperledger/fabric-ca/ca/ca.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/ca-admin
export FABRIC_CA_CLIENT_MSPDIR=/etc/hyperledger/orderers/orderer1.fabric.com/msp
fabric-ca-client enroll -d -u https://orderer1.fabric.com:ordererpw@ca.fabric.com:7152
sleep 2

tree /etc/hyperledger

# Enroll Orderer's Admin
export FABRIC_CA_CLIENT_MSPDIR=/etc/hyperledger/users/admin@fabric.com/msp
fabric-ca-client enroll -d -u https://admin@fabric.com:ordereradminpw@ca.fabric.com:7152
sleep 2

tree /etc/hyperledger

# AdminCerts
fabric-ca-client identity list
fabric-ca-client certificate list --id admin@fabric.com --store /etc/hyperledger/users/admin@fabric.com/msp/admincerts

# Copy AdminCerts to Orderer MSP AdminCerts
cp /etc/hyperledger/users/admin@fabric.com/msp/admincerts/*.pem /etc/hyperledger/orderers/orderer1.fabric.com/msp/admincerts

tree /etc/hyperledger

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
