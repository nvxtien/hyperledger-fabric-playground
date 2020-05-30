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
echo " Setup peer CA ca.po1.fabric.com"
echo " ------------------------------------------------------------------------------------------------------ "

set -x
export FABRIC_CA_CLIENT_TLS_CERTFILES=/etc/hyperledger/po1.fabric.com/ca-server/ca/ca.po1.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/po1.fabric.com/ca-admin

fabric-ca-client enroll -d -u https://rca-po1-admin:rca-po1-adminpw@ca.po1.fabric.com:7153
fabric-ca-client register -d --id.name peer0.po1.fabric.com --id.secret peer1PW --id.type peer -u https://ca.po1.fabric.com:7153
fabric-ca-client register -d --id.name peer1.po1.fabric.com --id.secret peer2PW --id.type peer -u https://ca.po1.fabric.com:7153
fabric-ca-client register -d --id.name admin@po1.fabric.com --id.secret po1AdminPW --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://ca.po1.fabric.com:7153
fabric-ca-client register -d --id.name user1@po1.fabric.com --id.secret po1UserPW --id.type user -u https://ca.po1.fabric.com:7153

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
