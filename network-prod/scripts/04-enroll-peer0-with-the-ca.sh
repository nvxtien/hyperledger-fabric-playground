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
echo " Enroll peer with CA "
echo "Peer is separate host the trusted root certificate has to be copied to Peer's host machine"
echo " ------------------------------------------------------------------------------------------------------ "

set -x

export FABRIC_CA_CLIENT_TLS_CERTFILES=/etc/hyperledger/po1.fabric.com/ca/ca.po1.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/po1.fabric.com/ca-admin
export FABRIC_CA_CLIENT_MSPDIR=/etc/hyperledger/po1.fabric.com/peers/peer0.po1.fabric.com/msp
fabric-ca-client enroll -d -u https://peer0.po1.fabric.com:peer1PW@ca.po1.fabric.com:7153 --csr.hosts peer0.po1.fabric.com

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
