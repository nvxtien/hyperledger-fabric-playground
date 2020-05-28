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

echo "------------------------------------------------------------------------------------------------------"
echo "Enroll and Setup peer org Admin User"
echo "The admin identity is responsible for activities such as # installing and instantiating chaincode.    "
echo "The commands below assumes that this is being executed on Peer1's host machine."
echo "Fabric does this by Creating folder user/Admin@po1.fabric.com"
echo "------------------------------------------------------------------------------------------------------"

set -x
export FABRIC_CA_CLIENT_TLS_CERTFILES=/etc/hyperledger/po1.fabric.com/ca/ca.po1.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/po1.fabric.com/ca-admin
export FABRIC_CA_CLIENT_MSPDIR=/etc/hyperledger/po1.fabric.com/users/admin@po1.fabric.com/msp
fabric-ca-client enroll -d -u https://admin@po1.fabric.com:po1AdminPW@ca.po1.fabric.com:7153

# AdminCerts
fabric-ca-client identity list
fabric-ca-client certificate list --id Admin@po1.fabric.com --store /etc/hyperledger/po1.fabric.com/users/admin@po1.fabric.com/msp/admincerts

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
