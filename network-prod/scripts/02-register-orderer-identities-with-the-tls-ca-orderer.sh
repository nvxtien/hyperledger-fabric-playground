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
export FABRIC_CA_CLIENT_TLS_CERTFILES=/etc/hyperledger/fabric-ca/tlsca/tlsca.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/tlsca-admin

fabric-ca-client enroll -d -u https://tls-ord-admin:tls-ord-adminpw@tlsca.fabric.com:7150
sleep 2
fabric-ca-client register -d --id.name orderer1.fabric.com --id.secret ordererPW --id.type orderer -u https://tlsca.fabric.com:7150
sleep 2
fabric-ca-client register -d --id.name admin@fabric.com --id.secret ordereradminpw --id.type admin -u https://tlsca.fabric.com:7150
sleep 2
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
