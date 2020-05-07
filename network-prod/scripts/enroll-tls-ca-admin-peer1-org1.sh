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
echo " Get binaries "
echo " ------------------------------------------------------------------------------------------------------ "
#curl -sSL https://bit.ly/2ysbOFE | bash -s -- 2.0.1 1.4.6 0.4.18

echo " ------------------------------------------------------------------------------------------------------ "
echo " Enroll TLS CA Admin"
echo " ------------------------------------------------------------------------------------------------------ "
pwd
cp $HOME/fabric-samples/bin/* /usr/local/bin/
set -x
mkdir -p /tmp/hyperledger/tls-ca/crypto
sudo chown ${USER} -R /tmp/hyperledger
scp root@tls-ca:/tmp/hyperledger/fabric-ca/crypto/ca-cert.pem /tmp/hyperledger/tls-ca/crypto/tls-ca-cert.pem
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/tls-ca/crypto/tls-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/tls-ca/admin
fabric-ca-client enroll -d -u https://tls-ca-admin:tls-ca-adminpw@tls-ca:7052
fabric-ca-client register -d --id.name peer1-org1 --id.secret peer1PW --id.type peer -u https://tls-ca:7052
set +x
#fabric-ca-client register -d --id.name peer2-org1 --id.secret peer2PW --id.type peer -u https://tls-ca:7052

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo

echo " Completed Defining the network"
exit 0
