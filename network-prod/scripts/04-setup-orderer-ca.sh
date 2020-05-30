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
echo " Setup orderer CA on ca.fabric.com"
echo " ------------------------------------------------------------------------------------------------------ "

set -x
export FABRIC_CA_CLIENT_TLS_CERTFILES=/etc/hyperledger/fabric.com/ca-server/ca/ca.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/fabric.com/ca-admin

fabric-ca-client enroll -d -u https://rca-orderer-admin:rca-orderer-adminpw@ca.fabric.com:7152
fabric-ca-client register -d --id.name orderer1.fabric.com --id.secret ordererpw --id.type orderer -u https://ca.fabric.com:7152
fabric-ca-client register -d --id.name admin@fabric.com --id.secret ordereradminpw --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://ca.fabric.com:7152

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
