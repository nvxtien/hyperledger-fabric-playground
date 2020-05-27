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

# cp $FABRIC_CFG_PATH/tls-rca/po1.fabric.com/tls/ca/server/tls-cert.pem $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca

# scp /etc/hyperledger/fabric-ca/tls-cert.pem root@peer0.po1.fabric.com/etc/hyperledger/po1.fabric.com/tlsca/
# scp /etc/hyperledger/fabric-ca/tls-cert.pem root@peer1.po1.fabric.com/etc/hyperledger/po1.fabric.com/tlsca/

export FABRIC_CA_CLIENT_TLS_CERTFILES=/etc/hyperledger/po1.fabric.com/tlsca/tlsca.po1.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/po1.fabric.com/tlsca-admin

export FABRIC_CA_CLIENT_MSPDIR=/etc/hyperledger/po1.fabric.com/peers/peer1.po1.fabric.com/tls
fabric-ca-client enroll -d -u https://peer1.po1.fabric.com:peer0PW@tlsca.po1.fabric.com:7151 --enrollment.profile tls --csr.hosts peer1.po1.fabric.com

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
