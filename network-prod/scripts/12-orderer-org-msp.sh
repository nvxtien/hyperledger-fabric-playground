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
echo "Orderer.org MSP"
echo " ------------------------------------------------------------------------------------------------------ "

set -x
echo "copy ca.fabric.com-cert.pem "
#scp /etc/hyperledger/fabric-ca/ca/ca.fabric.com-cert.pem root@orderer1.fabric.com:/etc/hyperledger/fabric-ca/ca/

# cacerts --orderer
export FABRIC_CA_CLIENT_TLS_CERTFILES=/etc/hyperledger/orderers/ca/ca.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/orderers/ca-admin
fabric-ca-client getcacert -u https://ca.fabric.com:7152 -M /etc/hyperledger/fabric.com/msp


# export FABRIC_CA_CLIENT_MSPDIR=/etc/hyperledger/users/admin@fabric.com/msp
# fabric-ca-client enroll -d -u https://admin@fabric.com:ordereradminpw@ca.fabric.com:7152
#fabric-ca-client identity list
#fabric-ca-client certificate list --id admin@fabric.com --store /etc/hyperledger/users/admin@fabric.com/msp/admincerts
#cp /etc/hyperledger/users/admin@fabric.com/msp/admincerts/*.pem /etc/hyperledger/orderers/orderer1.fabric.com/msp/admincerts/


# AdminCerts --orderer ?////

export FABRIC_CA_CLIENT_TLS_CERTFILES=/etc/hyperledger/orderers/ca/ca.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/orderers/ca-admin
fabric-ca-client enroll -d -u https://admin@fabric.com:ordereradminpw@ca.fabric.com:7152

fabric-ca-client identity list
fabric-ca-client certificate list --id admin@fabric.com --store /etc/hyperledger/fabric.com/msp/admincerts

# fabric-ca-client identity list
# fabric-ca-client certificate list --id admin@fabric.com --store /etc/hyperledger/orderer/msp/admincerts

# ca.fabric.com -> orderer1.fabric.com ???????????????????????????????????????
# scp /etc/hyperledger/orderers/orderer1.fabric.com/msp/admincerts/admin@fabric.com.pem root@orderer1.fabric.com:/etc/hyperledger/orderer/msp/admincerts/
scp root@ca.fabric.com:/etc/hyperledger/orderers/orderer1.fabric.com/msp/admincerts/admin@fabric.com.pem /etc/hyperledger/orderer/msp/admincerts/
scp root@ca.fabric.com:/etc/hyperledger/orderers/orderer1.fabric.com/msp/admincerts/admin@fabric.com.pem /etc/hyperledger/orderer/msp/admincerts/

# tlscacerts --orderer
echo "copy tlsca.fabric.com-cert.pem "
scp root@tlsca.fabric.com:/etc/hyperledger/fabric-ca/tlsca/tlsca.fabric.com-cert.pem /etc/hyperledger/fabric-ca/tlsca/

export FABRIC_CA_CLIENT_TLS_CERTFILES=/etc/hyperledger/orderers/tlsca/tlsca.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/orderers/tlsca-admin
fabric-ca-client getcacert -u https://tlsca.fabric.com:7150 -M /etc/hyperledger/fabric.com/msp --enrollment.profile tls

# delete keystore and signcerts empty dir

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
