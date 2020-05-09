#!/usr/bin/env bash

echo " # -------------------------------------------------- "
echo "# Create The MSP directory for Orgs "
echo "# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ "
echo "# On the orderer's host machine, we need to collect   "
echo "the MSPs for all the # organizations. "
echo "# ------------------------------------"
echo "#The MSP for Org will contain         "
echo "# 1. The trusted root certificate of Org, "
echo "# 2. The certificate of the Org's admin identity, "
echo "# 3. The trusted root certificate of the TLS CA.  "
echo "# The MSP folder structure can be seen below.     "

set -x
makdir -p /tmp/hyperledger/org0/msp/{cacerts,tlscacerts,admincerts}
echo " admincerts --orderer "

cp /tmp/hyperledger/org0/orderer/assets/ca/org0-ca-cert.pem /tmp/hyperledger/org0/msp/admincerts/admin-org0-cert.pem
cp /tmp/hyperledger/org0/orderer/assets/ca/org0-ca-cert.pem /tmp/hyperledger/org0/msp/cacerts/org0-ca-cert.pem
cp /tmp/hyperledger/org0/orderer/assets/tls-ca/tls-ca-cert.pem /tmp/hyperledger/org0/msp/tlscacerts/tls-ca-cert.pem

#export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/ca/ca.fabric.com-cert.pem
#export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/fabric.com/ca-admin
#fabric-ca-client getcacert -u https://0.0.0.0:7152 -M $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/msp

# AdminCerts --orderer
#fabric-ca-client identity list
#fabric-ca-client certificate list --id Admin@fabric.com --store $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/msp/admincerts

# tlscacerts --orderer
#export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/tlsca/tlsca.fabric.com-cert.pem
#export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/fabric.com/tlsca-admin
#fabric-ca-client getcacert -u https://0.0.0.0:7150 -M $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/msp --enrollment.profile tls

makdir -p /tmp/hyperledger/org1/msp/{cacerts,tlscacerts,admincerts}
cp root:peer1-org1:/tmp/hyperledger/org1/peer1/assets/ca/org1-ca-cert.pem /tmp/hyperledger/org1/msp/admincerts/admin-org0-cert.pem
cp root:peer1-org1:/tmp/hyperledger/org1/peer1/assets/ca/org1-ca-cert.pem /tmp/hyperledger/org1/msp/cacerts/org0-ca-cert.pem
cp root:peer1-org1:/tmp/hyperledger/org1/peer1/assets/tls-ca/tls-ca-cert.pem /tmp/hyperledger/org1/msp/tlscacerts/tls-ca-cert.pem