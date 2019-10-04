#!/bin/sh
echo
echo " ____    _____      _      ____    _____ "
echo "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echo "\___ \    | |     / _ \   | |_) |   | |  "
echo " ___) |   | |    / ___ \  |  _ <    | |  "
echo "|____/    |_|   /_/   \_\ |_| \_\   |_|  "
echo
echo "Creating artifacts for blockchain network"
echo

export FABRIC_CFG_PATH=$PWD

rm -rf $FABRIC_CFG_PATH/channel-artifacts/*
rm -rf $FABRIC_CFG_PATH/logs/*

mkdir -p $FABRIC_CFG_PATH/channel-artifacts/
mkdir -p $FABRIC_CFG_PATH/logs/


set +x
echo " --------------------------------------------------------------------------------------------------------------- "
ecgo " Create Peer config.yaml "
echo " --------------------------------------------------------------------------------------------------------------- "

# nano $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/config.yaml

# NodeOUs:
#  Enable: true
#  ClientOUIdentifier:
#    Certificate: cacerts/0-0-0-0-7054.pem
#    OrganizationalUnitIdentifier: client
#  PeerOUIdentifier:
#    Certificate: cacerts/0-0-0-0-7054.pem
#    OrganizationalUnitIdentifier: peer

set -x
echo "
NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/0-0-0-0-7153.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/0-0-0-0-7153.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/0-0-0-0-7153.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/0-0-0-0-7153.pem
    OrganizationalUnitIdentifier: orderer
" > $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/config.yaml

echo "
NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/0-0-0-0-7153.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/0-0-0-0-7153.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/0-0-0-0-7153.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/0-0-0-0-7153.pem
    OrganizationalUnitIdentifier: orderer
" > $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/msp/config.yaml

echo "
NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/0-0-0-0-7153.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/0-0-0-0-7153.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/0-0-0-0-7153.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/0-0-0-0-7153.pem
    OrganizationalUnitIdentifier: orderer
" > $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/config.yaml


echo "
NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/0-0-0-0-7152.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/0-0-0-0-7152.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/0-0-0-0-7152.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/0-0-0-0-7152.pem
    OrganizationalUnitIdentifier: orderer
" > $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/orderers/orderer1.fabric.com/msp/config.yaml


#NodeOUs:
#  Enable: true
#  ClientOUIdentifier:
#    Certificate: cacerts/ca.example.com-cert.pem
#    OrganizationalUnitIdentifier: client
#  PeerOUIdentifier:
#    Certificate: cacerts/ca.example.com-cert.pem
#    OrganizationalUnitIdentifier: peer
#  AdminOUIdentifier:
#    Certificate: cacerts/ca.example.com-cert.pem
#    OrganizationalUnitIdentifier: admin
#  OrdererOUIdentifier:
#    Certificate: cacerts/ca.example.com-cert.pem
#    OrganizationalUnitIdentifier: orderer

set +x
echo " --------------------------------------------------------------------------------------------------------------- "
echo " Create Genesis Block and Channel Transaction "
echo " --------------------------------------------------------------------------------------------------------------- "

set -x
# Create the orderer genesis block
configtxgen -profile OneOrgsOrdererGenesis -channelID rtr-sys-channel -outputBlock $FABRIC_CFG_PATH/channel-artifacts/genesis.block

# Create the channel
export CHANNEL_NAME=fabchannel01
configtxgen -profile OneOrgsChannel -outputCreateChannelTx $FABRIC_CFG_PATH/channel-artifacts/channel.tx -channelID $CHANNEL_NAME

set +x
echo " --------------------------------------------------------------------------------------------------------------- "
echo " Defining anchor peers "
echo " --------------------------------------------------------------------------------------------------------------- "

set -x
configtxgen -profile OneOrgsChannel -outputAnchorPeersUpdate $FABRIC_CFG_PATH/channel-artifacts/po1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg po1MSP

configtxgen -inspectBlock $FABRIC_CFG_PATH/channel-artifacts/genesis.block > $FABRIC_CFG_PATH/logs/genesisblock.txt
configtxgen -inspectChannelCreateTx $FABRIC_CFG_PATH/channel-artifacts/channel.tx > $FABRIC_CFG_PATH/logs/channeltx.txt
configtxgen -inspectChannelCreateTx $FABRIC_CFG_PATH/channel-artifacts/po1MSPanchors.tx > $FABRIC_CFG_PATH/logs/po1MSPanchors.txt
tree $FABRIC_CFG_PATH/crypto-config > $FABRIC_CFG_PATH/logs/crypto-tree.txt

####
#docker-compose -f docker-compose-cli.yaml up -d orderer1.fabric.com
#docker-compose -f docker-compose-cli.yaml up peer0.po1.fabric.com
#docker-compose -f docker-compose-cli.yaml up -d peer1.po1.fabric.com
#docker-compose -f docker-compose-cli.yaml up -d cli
#####

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
