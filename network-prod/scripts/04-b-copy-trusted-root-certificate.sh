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
echo "Peer is separate host the trusted root certificate has to be copied to Peer's host machine"
echo " ------------------------------------------------------------------------------------------------------ "

set -x

scp /etc/hyperledger/fabric-ca/ca/ca.po1.fabric.com-cert.pem root@peer0.po1.fabric.com:/etc/hyperledger/po1.fabric.com/ca/
scp /etc/hyperledger/fabric-ca/ca/ca.po1.fabric.com-cert.pem root@peer1.po1.fabric.com:/etc/hyperledger/po1.fabric.com/ca/

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
