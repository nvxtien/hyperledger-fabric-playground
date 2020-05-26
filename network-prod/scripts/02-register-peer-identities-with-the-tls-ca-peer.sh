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

set -x
export FABRIC_CA_CLIENT_TLS_CERTFILES=/etc/hyperledger/tlsca/tlsca.po1.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/tlsca-admin

fabric-ca-client enroll -d -u https://tls-peer-admin:tls-peer-adminpw@tlsca.po1.fabric.com:7151
fabric-ca-client register -d --id.name peer0.po1.fabric.com --id.secret peer0PW --id.type peer -u https://tlsca.po1.fabric.com:7151
fabric-ca-client register -d --id.name peer1.po1.fabric.com --id.secret peer0PW --id.type peer -u https://tlsca.po1.fabric.com:7151
fabric-ca-client register -d --id.name admin@po1.fabric.com --id.secret po1AdminPW --id.type admin -u https://tlsca.po1.fabric.com:7151

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
