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
echo " Setup Org1's peer1"
echo " ------------------------------------------------------------------------------------------------------ "

echo " ------------------------------------------------------------------------------------------------------ "
echo " This operation happening on orderer1-org0"
echo " ------------------------------------------------------------------------------------------------------ "
echo " You must do configuration as the following before issuing this script"
echo " - enable rca-org0 to be ssh with password"
echo " - enable rca-org0 to be scp without password"

set -x
mkdir -p /tmp/hyperledger/org0/orderer/assets/ca
scp -i aws.pem root@rca-org0:/tmp/hyperledger/fabric-ca/crypto/ca-cert.pem /tmp/hyperledger/org0/orderer/assets/ca/org0-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/orderer
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer/assets/ca/org0-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1-org0:ordererpw@rca-org0:7053

echo " ------------------------------------------------------------------------------------------------------ "
echo " get the TLS cryptographic material for the orderer"

mkdir -p /tmp/hyperledger/org0/orderer/assets/tls-ca
scp root@tls-ca:/tmp/hyperledger/fabric-ca/crypto/ca-cert.pem /tmp/hyperledger/org0/orderer/assets/tls-ca/tls-ca-cert.pem

export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://orderer1-org0:ordererPW@tls-ca:7052 --enrollment.profile tls --csr.hosts orderer1-org0

echo " ------------------------------------------------------------------------------------------------------ "
echo " Go to path /tmp/hyperledger/org0/orderer/tls-msp/keystore and change the name of the key to key.pem"
cp /tmp/hyperledger/org0/orderer/tls-msp/keystore/$(ls /tmp/hyperledger/org0/orderer/tls-msp/keystore) /tmp/hyperledger/org0/orderer/tls-msp/keystore/key.pem
ls /tmp/hyperledger/org0/orderer/tls-msp/keystore

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
