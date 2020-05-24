#!/usr/bin/env bash

echo " # -------------------------------------------------- "
echo "# Create The MSP directory for Orgs (orderer1-org0)"
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
mkdir -p /tmp/hyperledger/org0/msp/{cacerts,tlscacerts,admincerts}
echo " admincerts --orderer "

echo "admincerts : The certificate of the Org's admin identity"

export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/ca/admin

#export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/admin
#export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer/assets/ca/org0-ca-cert.pem

fabric-ca-client identity list
fabric-ca-client certificate list --id admin-org0 --store /tmp/hyperledger/org0/msp/admincerts
#/tmp/hyperledger/org0/ca/admin/msp/cacerts/rca-org0-7053.pem
#the certificate for this identity

echo "cacerts: The trusted root certificate of Org's CA"

export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org0/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org0/orderer/assets/ca/org0-ca-cert.pem
fabric-ca-client getcacert -u https://rca-org0:7053 -M /tmp/hyperledger/org0/msp
#/tmp/hyperledger/org0/msp/cacerts/rca-org0-7053.pem == /tmp/hyperledger/org0/orderer/assets/ca/org0-ca-cert.pem
#

echo "tlscacerts: The trusted root certificate of the Org's TLS CA"
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/tls-ca/crypto/tls-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/tls-ca/admin
fabric-ca-client getcacert -u https://tls-ca:7052 -M /tmp/hyperledger/org0/msp --enrollment.profile tls




mkdir -p /tmp/hyperledger/org1/msp/{cacerts,tlscacerts,admincerts}

export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/ca/crypto/ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org1/ca/admin

#export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org1/admin
#export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/peer1/assets/ca/org1-ca-cert.pem
fabric-ca-client identity list
fabric-ca-client certificate list --id admin-org1 --store /tmp/hyperledger/org1/msp/admincerts


export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/org1/admin
export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/org1/peer1/assets/ca/org1-ca-cert.pem
fabric-ca-client getcacert -u https://rca-org1:7054 -M /tmp/hyperledger/org1/msp
#/tmp/hyperledger/org1/msp/cacerts/rca-org1-7054.pem


export FABRIC_CA_CLIENT_TLS_CERTFILES=/tmp/hyperledger/tls-ca/crypto/tls-ca-cert.pem
export FABRIC_CA_CLIENT_HOME=/tmp/hyperledger/tls-ca/admin
fabric-ca-client getcacert -u https://tls-ca:7052 -M /tmp/hyperledger/org1/msp --enrollment.profile tls

scp root@peer1-org1:/tmp/hyperledger/org1/msp/cacerts/rca-org1-7054.pem /tmp/hyperledger/org1/msp/cacerts/rca-org1-7054.pem
scp root@peer1-org1:/tmp/hyperledger/org1/msp/tlscacerts/tls-tls-ca-7052.pem /tmp/hyperledger/org1/msp/tlscacerts/tls-tls-ca-7052.pem
scp root@peer1-org1:/tmp/hyperledger/org1/peer1/msp/admincerts/org1-admin-cert.pem /tmp/hyperledger/org1/msp/admincerts/org1-admin-cert.pem


#/tmp/hyperledger/org1/msp/tlscacerts/tls-tls-ca-7052.pem

#scp root@peer1-org1:/tmp/hyperledger/org1/peer1/msp/admincerts/org1-admin-cert.pem /tmp/hyperledger/org1/msp/admincerts/admin-org1-cert.pem
#scp root@peer1-org1:/tmp/hyperledger/org1/peer1/assets/ca/org1-ca-cert.pem /tmp/hyperledger/org1/msp/cacerts/org1-ca-cert.pem
##scp root@peer1-org1:/tmp/hyperledger/org1/peer1/assets/ca/org1-ca-cert.pem /tmp/hyperledger/org1/msp/cacerts/org0-ca-cert.pem

##scp root@peer1-org1:/tmp/hyperledger/org1/ca/admin/msp/signcerts/cert.pem /tmp/hyperledger/org1/msp/cacerts/org0-ca-cert.pem


scp root@peer1-org1:/tmp/hyperledger/org1/peer1/assets/tls-ca/tls-ca-cert.pem /tmp/hyperledger/org1/msp/tlscacerts/tls-ca-cert.pem




scp root@peer1-org1:/tmp/hyperledger/org1/peer1/msp/admincerts/org1-admin-cert.pem /tmp/hyperledger/org1/msp/admincerts/org1-admin-cert.pem

scp root@peer1-org1:/tmp/hyperledger/org1/peer1/msp/admincerts/rca-org1-7054.pem /tmp/hyperledger/org1/msp/cacerts/rca-org1-7054.pem