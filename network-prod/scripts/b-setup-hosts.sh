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

ssh root@tls-ca "echo
\"
45.32.115.109 	tls-ca
207.148.70.147 	rca-org0
139.180.152.195 orderer1-org0
139.180.188.181 rca-org1
207.148.119.17 	peer1-org1
149.28.135.193 	peer2-org1
\" | tee -a /etc/hosts"

ssh root@rca-org0 "echo
\"
45.32.115.109 	tls-ca
207.148.70.147 	rca-org0
139.180.152.195 orderer1-org0
139.180.188.181 rca-org1
207.148.119.17 	peer1-org1
149.28.135.193 	peer2-org1
\" | tee -a /etc/hosts"


ssh root@orderer1-org0 "echo
\"
45.32.115.109 	tls-ca
207.148.70.147 	rca-org0
139.180.152.195 orderer1-org0
139.180.188.181 rca-org1
207.148.119.17 	peer1-org1
149.28.135.193 	peer2-org1
\" | tee -a /etc/hosts"

ssh root@rca-org1 "echo
\"
45.32.115.109 	tls-ca
207.148.70.147 	rca-org0
139.180.152.195 orderer1-org0
139.180.188.181 rca-org1
207.148.119.17 	peer1-org1
149.28.135.193 	peer2-org1
\" | tee -a /etc/hosts"

ssh root@peer1-org1 "echo
\"
45.32.115.109 	tls-ca
207.148.70.147 	rca-org0
139.180.152.195 orderer1-org0
139.180.188.181 rca-org1
207.148.119.17 	peer1-org1
149.28.135.193 	peer2-org1
\" | tee -a /etc/hosts"

ssh root@peer2-org1 "echo
\"
45.32.115.109 	tls-ca
207.148.70.147 	rca-org0
139.180.152.195 orderer1-org0
139.180.188.181 rca-org1
207.148.119.17 	peer1-org1
149.28.135.193 	peer2-org1
\" | tee -a /etc/hosts"

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
