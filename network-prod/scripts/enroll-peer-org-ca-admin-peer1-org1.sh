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
echo " Enroll Peer Org's CA Admin and Peer1 identity"
echo " ------------------------------------------------------------------------------------------------------ "

echo " ------------------------------------------------------------------------------------------------------ "
echo " This operation happening on peer1-org1"
echo " ------------------------------------------------------------------------------------------------------ "
echo " You must do configuration as the following before issuing this script"
echo " - enable rca-org1 to be ssh with password"
echo " - enable rca-org1 to be scp without password"

set -x
mkdir -p /tmp/hyperledger/org1/ca/crypto
scp root@rca-org1:/tmp/hyperledger/fabric-ca/crypto/ca-cert.pem /tmp/hyperledger/org1/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org1/ca/admin
fabric-ca-client enroll -d -u https://rca-org1-admin:rca-org1-adminpw@rca-org1:7054
fabric-ca-client register -d --id.name peer1-org1 --id.secret peer1PW --id.type peer -u https://rca-org1:7054
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
