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
echo "Peer Org MSP"
echo " ------------------------------------------------------------------------------------------------------ "

set -x
mkdir -p /etc/hyperledger/po1.fabric.com/msp/{cacerts,tlscacerts,admincerts}
# cacerts --peer org
export FABRIC_CA_CLIENT_TLS_CERTFILES=/etc/hyperledger/po1.fabric.com/ca/ca.po1.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/po1.fabric.com/ca-admin
fabric-ca-client getcainfo -u https://ca.po1.fabric.com:7153 -M /etc/hyperledger/po1.fabric.com/msp

# AdminCerts --peer org ??????????
fabric-ca-client identity list
fabric-ca-client certificate list --id Admin@po1.fabric.com --store $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/msp/admincerts

cp /etc/hyperledger/po1.fabric.com/peers/peer0.po1.fabric.com/msp/admincerts/cert.pem /etc/hyperledger/po1.fabric.com/msp/admincerts/
cp /etc/hyperledger/po1.fabric.com/peers/peer1.po1.fabric.com/msp/admincerts/cert.pem /etc/hyperledger/po1.fabric.com/msp/admincerts/

# tlscacerts --peer org
export FABRIC_CA_CLIENT_TLS_CERTFILES=/etc/hyperledger/po1.fabric.com/tlsca/tlsca.po1.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/po1.fabric.com/tlsca-admin
fabric-ca-client getcacert -u https://tlsca.po1.fabric.com:7151 -M /etc/hyperledger/po1.fabric.com/msp --enrollment.profile tls

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
