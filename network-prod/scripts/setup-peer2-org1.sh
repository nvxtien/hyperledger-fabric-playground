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
echo " This operation happening on peer2-org1"
echo " ------------------------------------------------------------------------------------------------------ "
echo " You must do configuration as the following before issuing this script"
echo " - enable rca-org1 to be ssh with password"
echo " - enable rca-org1 to be scp without password"

set -x
mkdir -p /tmp/hyperledger/org1/peer2/assets/ca
scp root@rca-org1:/tmp/hyperledger/fabric-ca/crypto/ca-cert.pem /tmp/hyperledger/org1/peer2/assets/ca/org1-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org1/peer2
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/peer2/assets/ca/org1-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=msp
fabric-ca-client enroll -d -u https://peer2-org1:peer2PW@rca-org1:7054
fabric-ca-client enroll -d -u https://peer1-org1:peer1PW@rca-org1:7054
set +x
echo " ------------------------------------------------------------------------------------------------------ "
echo " get the TLS cryptographic material for the peer"

set -x
mkdir -p /tmp/hyperledger/org1/peer2/assets/tls-ca
scp root@tls-ca:/tmp/hyperledger/fabric-ca/crypto/ca-cert.pem /tmp/hyperledger/org1/peer2/assets/tls-ca/tls-ca-cert.pem
export FABRIC_CA_CLIENT_MSPDIR=tls-msp
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/peer2/assets/tls-ca/tls-ca-cert.pem
fabric-ca-client enroll -d -u https://peer2-org1:peer2PW@tls-ca:7052 --enrollment.profile tls --csr.hosts peer2-org1
set +x

echo " ------------------------------------------------------------------------------------------------------ "
echo " Go to path /tmp/hyperledger/org1/peer2/tls-msp/keystore  and change the name of the key to key.pem. This will make it easy to be able to refer to in later steps."

set -x
cp /tmp/hyperledger/org1/peer2/tls-msp/keystore /$(ls /tmp/hyperledger/org1/peer2/tls-msp/keystore) /tmp/hyperledger/org1/peer2/tls-msp/keystore/key.pem
ls /tmp/hyperledger/org1/peer2/tls-msp/keystore
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
