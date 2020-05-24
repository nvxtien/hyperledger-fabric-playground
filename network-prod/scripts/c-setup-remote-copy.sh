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

echo " ------------------------------------------------------------------------------------------------------ "
echo " Copy from Peer Org1's CA "
echo " /etc/hosts"
echo " ssh-copy-id"
echo " ------------------------------------------------------------------------------------------------------ "
set -x

#ssh root@peer1-org1 "ssh-keygen -t rsa"
#ssh root@peer1-org1 "ssh-copy-id -i \$HOME/.ssh/id_rsa.pub root@tls-ca"
ssh root@peer1-org1 "ssh-copy-id -i /root/.ssh/id_rsa.pub root@rca-org1"
ssh root@peer1-org1 "ssh-copy-id -i /root/.ssh/id_rsa.pub root@peer2-org1"

#ssh root@peer2-org1 "ssh-keygen -t rsa"
ssh root@peer2-org1 "ssh-copy-id -i /root/.ssh/id_rsa.pub root@tls-ca"
ssh root@peer2-org1 "ssh-copy-id -i /root/.ssh/id_rsa.pub root@rca-org1"
ssh root@peer2-org1 "ssh-copy-id -i /root/.ssh/id_rsa.pub root@peer1-org1"

#ssh root@orderer1-org0 "ssh-keygen -t rsa"
ssh root@orderer1-org0 "ssh-copy-id -i /root/.ssh/id_rsa.pub root@tls-ca"
ssh root@orderer1-org0 "ssh-copy-id -i /root/.ssh/id_rsa.pub root@rca-org0"
#ssh root@orderer1-org0 "ssh-copy-id -i /root/.ssh/id_rsa.pub root@rca-org1"

ssh root@orderer1-org0 "ssh-copy-id -i /root/.ssh/id_rsa.pub root@peer1-org1"

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
