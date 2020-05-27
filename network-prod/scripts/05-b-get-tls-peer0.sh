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
echo " Enroll and Get the TLS cryptographic material for the peer "
echo " Copy TLS CA from TLS if on another server "
echo " tlsca.po1.fabric.com -> peer0.po1.fabric.com, peer1.po1.fabric.com"
echo " ------------------------------------------------------------------------------------------------------ "

set -x

scp /etc/hyperledger/fabric-ca/tls-cert.pem root@peer0.po1.fabric.com/etc/hyperledger/po1.fabric.com/tlsca/
scp /etc/hyperledger/fabric-ca/tls-cert.pem root@peer1.po1.fabric.com/etc/hyperledger/po1.fabric.com/tlsca/

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
