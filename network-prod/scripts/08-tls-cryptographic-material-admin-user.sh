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
echo "Enroll and Get the TLS cryptographic material for the Admin User"
echo "Enroll against the ``tls`` profile on the TLS CA. Using Tls cert..    "
echo "------------------------------------------------------------------------------------------------------"

set -x

export FABRIC_CA_CLIENT_TLS_CERTFILES=/etc/hyperledger/po1.fabric.com/tlsca/tlsca.po1.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/po1.fabric.com/tlsca-admin
export FABRIC_CA_CLIENT_MSPDIR=/etc/hyperledger/po1.fabric.com/users/admin@po1.fabric.com/tls
fabric-ca-client enroll -d -u https://admin@po1.fabric.com:po1AdminPW@tlsca.po1.fabric.com:7151 --enrollment.profile tls

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
