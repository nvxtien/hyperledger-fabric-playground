#!/bin/sh
echo
echo " ____    _____      _      ____    _____ "
echo "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echo "\___ \    | |     / _ \   | |_) |   | |  "
echo " ___) |   | |    / ___ \  |  _ <    | |  "
echo "|____/    |_|   /_/   \_\ |_| \_\   |_|  "
echo
echo "Fabric CA TLS"
echo

docker-compose up ca-tls

# you copy the file located at /tmp/hyperledger/tls-ca/crypto/ca-cert.pem to the host where you will be running the CA client binary.
# /tmp/hyperledger/tls-ca/crypto/tls-ca-cert.pem

# fabric-ca-client enroll -u http://user:userpw@serverAddr:serverPort

# fabric-ca-client enroll -d -u https://tls-ca-admin:tls-ca-adminpw@0.0.0.0:7052

# fabric-ca-client enroll -d -u https://peer:peer1PW@0.0.0.0:7052
# fabric-ca-client register -d --id.name peer1-org1 --id.secret peer1PW --id.type peer -u https://0.0.0.0:7052


echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo

echo " Completed Defining the network"
exit 0
