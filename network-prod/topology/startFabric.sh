#!/bin/sh
echo
echo " ____    _____      _      ____    _____ "
echo "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echo "\___ \    | |     / _ \   | |_) |   | |  "
echo " ___) |   | |    / ___ \  |  _ <    | |  "
echo "|____/    |_|   /_/   \_\ |_| \_\   |_|  "
echo
echo "Define Basic network by Tien"
echo

export FABRIC_CFG_PATH=$PWD

rm -rf $FABRIC_CFG_PATH//fabca/
rm -rf $FABRIC_CFG_PATH/crypto-config/

mkdir -p $FABRIC_CFG_PATH/fabca/fabric.com/{ca-admin,ca-server,tlsca-admin,tlsca-server}
mkdir -p $FABRIC_CFG_PATH/fabca/po1.fabric.com/{ca-admin,ca-server,tlsca-admin,tlsca-server}

mkdir -p $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca
mkdir -p $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/tlsca

docker-compose -f docker-compose-tlsca.yaml down
docker network rm fab-net

echo " ------------------------------------------------------------------------------------------------------ "
echo " Setup the Docker External Network "
echo " ------------------------------------------------------------------------------------------------------ "
docker network create --driver bridge fab-net

echo " ------------------------------------------------------------------------------------------------------ "
echo " Start TLS CA for ORDER ORG "
echo " ------------------------------------------------------------------------------------------------------ "
docker-compose -f docker-compose-tlsca.yaml up -d tlsca.fabric.com
echo " For view realtime logs: docker logs -f tlsca.fabric.com "

echo " ------------------------------------------------------------------------------------------------------ "
echo " Start TLS CA for PEER ORG "
echo " ------------------------------------------------------------------------------------------------------ "
docker-compose -f docker-compose-tlsca.yaml up -d tlsca.po1.fabric.com
echo " For view realtime logs: docker logs -f tlsca.po1.fabric.com "

sleep 10

cp $FABRIC_CFG_PATH/fabca/fabric.com/tlsca-server/msp/keystore/*_sk  $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/tlsca/
cp $FABRIC_CFG_PATH/fabca/po1.fabric.com/tlsca-server/msp/keystore/*_sk  $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca/

echo " ------------------------------------------------------------------------------------------------------ "
echo " Register orderer identities with the tls-ca-orderer "
echo " ------------------------------------------------------------------------------------------------------ "

export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/tlsca/tlsca.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/fabric.com/tlsca-admin
fabric-ca-client enroll -d -u https://tls-ord-admin:tls-ord-adminpw@0.0.0.0:7150
sleep 10
fabric-ca-client register -d --id.name orderer1.fabric.com --id.secret ordererPW --id.type orderer -u https://0.0.0.0:7150
sleep 10
fabric-ca-client register -d --id.name Admin@fabric.com --id.secret ordereradminpw --id.type admin -u https://0.0.0.0:7150
sleep 10

echo
echo " _____   _   _   ____   "
echo "| ____| | \ | | |  _ \  "
echo "|  _|   |  \| | | | | | "
echo "| |___  | |\  | | |_| | "
echo "|_____| |_| \_| |____/  "
echo

echo " Completed Defining the network"
exit 0
