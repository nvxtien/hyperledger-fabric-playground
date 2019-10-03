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

rm -rf $FABRIC_CFG_PATH/fabca/
rm -rf $FABRIC_CFG_PATH/crypto-config/

mkdir -p $FABRIC_CFG_PATH/fabca/fabric.com/{ca-admin,ca-server,tlsca-admin,tlsca-server}
mkdir -p $FABRIC_CFG_PATH/fabca/po1.fabric.com/{ca-admin,ca-server,tlsca-admin,tlsca-server}
mkdir -p $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca
mkdir -p $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/tlsca

docker-compose -f docker-compose-tlsca.yaml down --remove-orphans
docker-compose -f docker-compose-rca.yaml down
docker-compose -f docker-compose-cli.yaml down

docker network rm fab-net

#docker network prune

echo " ------------------------------------------------------------------------------------------------------ "
echo " Setup the Docker External Network "
echo " ------------------------------------------------------------------------------------------------------ "
docker network create --driver bridge fab-net

#fabric-ca-server init  creates server cert.pem and key.pem
#docker-compose -f docker-compose-tlsca.yaml up
#docker-compose -f docker-compose-tlsca.yaml up tlsca.fabric.com
#docker-compose -f docker-compose-tlsca.yaml up tlsca.po1.fabric.com

#cp $FABRIC_CFG_PATH/fabca/fabric.com/tlsca-server/msp/keystore/*6d_sk  $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/tlsca/tlsca.fabric.com-key.pem
#cp $FABRIC_CFG_PATH/fabca/po1.fabric.com/tlsca-server/msp/keystore/*ce_sk  $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca/tlsca.po1.fabric.com-key.pem

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

sleep 2

echo " ------------------------------------------------------------------------------------------------------ "
echo " Register orderer identities with the tls-ca-orderer "
echo " ------------------------------------------------------------------------------------------------------ "

export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/tlsca/tlsca.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/fabric.com/tlsca-admin
fabric-ca-client enroll -u https://tls-ord-admin:tls-ord-adminpw@0.0.0.0:7150
fabric-ca-client register --id.name orderer1.fabric.com --id.secret ordererPW --id.type orderer -u https://0.0.0.0:7150
fabric-ca-client register --id.name Admin@fabric.com --id.secret ordereradminpw --id.type admin -u https://0.0.0.0:7150

#export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/tlsca/tlsca.fabric.com-cert.pem
#export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/fabric.com/tlsca-admin
#fabric-ca-client enroll -d -u https://tls-ord-admin:tls-ord-adminpw@0.0.0.0:7150
#fabric-ca-client register -d — id.name orderer1.fabric.com — id.secret ordererPW — id.type orderer -u https://0.0.0.0:7150
#fabric-ca-client register -d — id.name Admin@fabric.com — id.secret ordereradminpw — id.type admin -u https://0.0.0.0:7150

set +x

echo " ------------------------------------------------------------------------------------------------------ "
echo " Register peer identities with the tls-ca-peer "
echo " ------------------------------------------------------------------------------------------------------ "

export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca/tlsca.po1.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/po1.fabric.com/tlsca-admin
fabric-ca-client enroll -u https://tls-peer-admin:tls-peer-adminpw@0.0.0.0:7151
fabric-ca-client register --id.name peer0.po1.fabric.com --id.secret peer0PW --id.type peer -u https://0.0.0.0:7151
fabric-ca-client register --id.name peer1.po1.fabric.com --id.secret peer0PW --id.type peer -u https://0.0.0.0:7151
fabric-ca-client register --id.name Admin@po1.fabric.com --id.secret po1AdminPW --id.type admin -u https://0.0.0.0:7151

#export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca/tlsca.po1.fabric.com-cert.pem
#export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/po1.fabric.com/tlsca-admin
#fabric-ca-client enroll -d -u https://tls-peer-admin:tls-peer-adminpw@0.0.0.0:7151
#fabric-ca-client register -d — id.name peer0.po1.fabric.com — id.secret peer0PW — id.type peer -u https://0.0.0.0:7151
#fabric-ca-client register -d — id.name peer1.po1.fabric.com — id.secret peer0PW — id.type peer -u https://0.0.0.0:7151
#fabric-ca-client register -d — id.name Admin@po1.fabric.com — id.secret po1AdminPW — id.type admin -u https://0.0.0.0:7151

set +x
echo " ------------------------------------------------------------------------------------------------------ "
echo " Setup orderer CA "
echo " Each organization must have it's own Certificate Authority (CA) for issuing enrollment certificates. "
echo " ------------------------------------------------------------------------------------------------------ "

#docker-compose -f docker-compose-rca.yaml up -d
#docker-compose -f docker-compose-rca.yaml down

docker-compose -f docker-compose-rca.yaml up -d ca.fabric.com
sleep 2
docker-compose -f docker-compose-rca.yaml up -d ca.po1.fabric.com
sleep 2

#[COPY MANUALLY]
cp $FABRIC_CFG_PATH/fabca/fabric.com/ca-server/msp/keystore/*_sk $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/ca/
cp $FABRIC_CFG_PATH/fabca/po1.fabric.com/ca-server/msp/keystore/*_sk $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/ca/

#cp 757391ada3e_sk /home/hyper/fabric/crypto-config/peerOrganizations/po1.fabric.com/ca
#cp 5d96720f_sk  /home/hyper/fabric/crypto-config/ordererOrganizations/fabric.com/ca

export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/ca/ca.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/fabric.com/ca-admin
fabric-ca-client enroll -d -u https://rca-orderer-admin:rca-orderer-adminpw@0.0.0.0:7152
fabric-ca-client register -d --id.name orderer1.fabric.com --id.secret ordererpw --id.type orderer -u https://0.0.0.0:7152
fabric-ca-client register -d --id.name Admin@fabric.com --id.secret ordereradminpw --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7152

#export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/ca/ca.fabric.com-cert.pem
#export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/fabric.com/ca-admin
#fabric-ca-client enroll -d -u https://rca-orderer-admin:rca-orderer-adminpw@0.0.0.0:7152
#fabric-ca-client register -d --id.name orderer1.fabric.com --id.secret ordererpw --id.type orderer -u https://0.0.0.0:7152
#fabric-ca-client register -d --id.name Admin@fabric.com --id.secret ordereradminpw --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert” -u https://0.0.0.0:7152

set +x

echo " ------------------------------------------------------------------------------------------------------ "
echo " Setup peer CA "
echo " ------------------------------------------------------------------------------------------------------ "

#cd $FABRIC_CFG_PATH/scripts
#docker-compose -f rca-po1.yaml up
#docker-compose -f rca-po1.yaml down

export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/ca/ca.po1.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/po1.fabric.com/ca-admin

fabric-ca-client enroll -d -u https://rca-po1-admin:rca-po1-adminpw@0.0.0.0:7153
fabric-ca-client register -d --id.name peer0.po1.fabric.com --id.secret peer1PW --id.type peer -u https://0.0.0.0:7153
fabric-ca-client register -d --id.name peer1.po1.fabric.com --id.secret peer2PW --id.type peer -u https://0.0.0.0:7153
fabric-ca-client register -d --id.name Admin@po1.fabric.com --id.secret po1AdminPW --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7153
fabric-ca-client register -d --id.name User1@po1.fabric.com --id.secret po1UserPW --id.type user -u https://0.0.0.0:7153

##fabric-ca-client identity list

#export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/ca/ca.po1.fabric.com-cert.pem
#export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/po1.fabric.com/ca-admin
#fabric-ca-client enroll -d -u https://rca-po1-admin:rca-po1-adminpw@0.0.0.0:7153
#fabric-ca-client register -d — id.name peer0.po1.fabric.com — id.secret peer1PW — id.type peer -u https://0.0.0.0:7153
#fabric-ca-client register -d — id.name peer1.po1.fabric.com — id.secret peer2PW — id.type peer -u https://0.0.0.0:7153
#fabric-ca-client register -d — id.name Admin@po1.fabric.com — id.secret po1AdminPW — id.type admin — id.attrs “hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert” -u https://0.0.0.0:7153
#fabric-ca-client register -d — id.name User1@po1.fabric.com — id.secret po1UserPW — id.type user -u https://0.0.0.0:7153


# ------------------------------------------------------------------------------------------------------
# Enroll and Get the TLS cryptographic material for the peer.
# This requires another enrollment,
# Enroll against the ``tls`` profile on the TLS CA.
#Copy TLS CA from TLS if on another server.

#cp $FABRIC_CFG_PATH/fabca/po1.fabric.com/tls/ca-server/tls-cert.pem $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca

export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca/tlsca.po1.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/po1.fabric.com/tlsca-admin

export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/tls
fabric-ca-client enroll -d -u https://peer0.po1.fabric.com:peer0PW@0.0.0.0:7151 --enrollment.profile tls --csr.hosts peer0.po1.fabric.com

export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/tls
fabric-ca-client enroll -d -u https://peer1.po1.fabric.com:peer0PW@0.0.0.0:7151 --enrollment.profile tls --csr.hosts peer1.po1.fabric.com

#export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/ca/ca.po1.fabric.com-cert.pem
#export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/po1.fabric.com/ca-admin
#Peer0:
#export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp
#fabric-ca-client enroll -d -u https://peer0.po1.fabric.com:peer1PW@0.0.0.0:7153 — csr.hosts peer0.po1.fabric.com
#Peer1
#export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/msp
#fabric-ca-client enroll -d -u https://peer1.po1.fabric.com:peer2PW@0.0.0.0:7153 — csr.hosts peer1.po1.fabric.com


# rename keystore = key.pem

mv $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/tls/keystore/*_sk $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/tls/keystore/key.pem
mv $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/tls/keystore/*_sk $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/tls/keystore/key.pem

  # Mutuall TLS Enables then rename
  # tls/signcerts/cert.pem = server.crt
  # tls/keystore/key.pem = server.key
  # tls/tlscacerts/tls-0-0-0-0-7151.pem = ca.crt

  # ------------------------------------------------------------------------------------------------------
  # Enroll and Setup peer org Admin User
  # The admin identity is responsible for activities such as # installing and instantiating chaincode.
  # The commands below assumes that this is being executed on Peer1's host machine.
  # Fabric does this by Creating folder user/Admin@po1.fabric.com
  # ------------------------------------------------------------------------------------------------------

export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/ca/ca.po1.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/po1.fabric.com/ca-admin

export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp
fabric-ca-client enroll -d -u https://Admin@po1.fabric.com:po1AdminPW@0.0.0.0:7153

#You can manually copy signcerts to admin certs or run below command.
#fabric-ca-client certificate list — id Admin@po1.fabric.com — store $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/admincerts

# AdminCerts
fabric-ca-client identity list
fabric-ca-client certificate list --id Admin@po1.fabric.com --store $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/admincerts

# --------------------------------------------------------------
  # Enroll user
export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/User1@po1.fabric.com/msp
fabric-ca-client enroll -d -u https://User1@po1.fabric.com:po1UserPW@0.0.0.0:7153

#Copy the admincerts certificate Admin@po1.fabric.com.pem from this Admin user MSP and move it to the Peer's MSP
# in the 'admincerts' directory. Copy this admin certificate to other peers in the org , use identity command above or
# copy to the 'admincerts' directory in each peers' MSP.

#[AAAAAAA]
##mkdir -p $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/admincerts
##cp $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/admincerts/*.pem $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/admincerts

# After enrollment, you should have an admin MSP.
  # You will copy the certificate from this MSP and move it to the Peer1's MSP in the ``admincerts``
  # folder. You will need to disseminate this admin certificate to other peers in the
  # org, and it will need to go in to the ``admincerts`` folder of each peers' MSP.

  # --------------------------------------------------------------
  # Alternate Method manual copy

#[AAAAAAA]
mkdir -p $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/admincerts
cp $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/signcerts/cert.pem $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/admincerts

#fabric-ca-client identity list
#fabric-ca-client certificate list --id User1@po1.fabric.com --store $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/admincerts

mkdir -p $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/signcerts
cp $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/signcerts/cert.pem $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/signcerts


mkdir -p $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/cacerts
cp $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/cacerts/*.pem $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/cacerts


mkdir -p $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/keystore
cp $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/keystore/* $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/keystore/

#mkdir -p $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/admincerts
#mkdir -p $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/{admincerts,cacerts,keystore,signcerts}

#cp $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/admincerts/*.pem $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/admincerts/
#cp $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/cacerts/*.pem $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/cacerts/
#cp $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/signcerts/cert.pem $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/admincerts/
#cp $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/*.* $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/

echo " Step below is applied for PEER1 "

#fabric-ca-client certificate list --id User1@po1.fabric.com --store $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/msp/admincerts

#[BBB]
#mkdir -p $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/msp/admincerts
#cp $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/admincerts/*.pem $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/msp/admincerts

#[BBB]
mkdir -p $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/msp/admincerts
cp $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/signcerts/cert.pem $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/msp/admincerts

mkdir -p $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/msp/signcerts
cp $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/signcerts/cert.pem $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/msp/signcerts

mkdir -p $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/msp/cacerts
cp $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/cacerts/*.pem $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/msp/cacerts

mkdir -p $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/msp/keystore
cp $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/keystore/* $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/msp/keystore/

# --------------------------------------------------------------
# Enroll and Get the TLS cryptographic material for the Admin User
# Enroll against the ``tls`` profile on the TLS CA. Using Tls cert.

export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca/tlsca.po1.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/po1.fabric.com/tlsca-admin

export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/tls
fabric-ca-client enroll -d -u https://Admin@po1.fabric.com:po1AdminPW@0.0.0.0:7151 --enrollment.profile tls

echo "At this point we can test run our peers : docker-compose -f docker-compose-cli.yaml up peer0.po1.fabric.com "
# ------------------------------------------------------------------------------------------------------
# Launch Org1's Peers
# ------------------------------------------------------------------------------------------------------

docker-compose -f docker-compose-cli.yaml up -d peer0.po1.fabric.com
sleep 3

docker-compose -f docker-compose-cli.yaml up -d peer1.po1.fabric.com
sleep 3

# ------------------------------------------------------------------------------------------------------------------------
  # Setup Orderer CA
  # ------------------------------------------------------------------------------------------------------------------------
  # Alternate Method manual copy

export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/ca/ca.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/fabric.com/ca-admin
export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/orderers/orderer1.fabric.com/msp
fabric-ca-client enroll -d -u https://orderer1.fabric.com:ordererpw@0.0.0.0:7152

# Enroll Orderer's Admin
export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/users/Admin@fabric.com/msp
fabric-ca-client enroll -d -u https://Admin@fabric.com:ordereradminpw@0.0.0.0:7152

# AdminCerts
fabric-ca-client identity list
fabric-ca-client certificate list --id Admin@fabric.com --store $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/users/Admin@fabric.com/msp/admincerts

# Copy AdminCerts to Orderer MSP AdminCerts
#mkdir $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/orderers/orderer1.fabric.com/msp/admincerts/
#cp $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/users/Admin@fabric.com/msp/admincerts/*.pem $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/orderers/orderer1.fabric.com/msp/admincerts/

# --------------------------------------------------------------------------------
  # Orderer TLS certificate.

export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/tlsca/tlsca.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/fabric.com/tlsca-admin
export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/orderers/orderer1.fabric.com/tls
fabric-ca-client enroll -d -u https://orderer1.fabric.com:ordererPW@0.0.0.0:7150 --enrollment.profile tls --csr.hosts orderer1.fabric.com

export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/users/Admin@fabric.com/tls
fabric-ca-client enroll -d -u https://Admin@fabric.com:ordereradminpw@0.0.0.0:7150 --enrollment.profile tls --csr.hosts orderer1.fabric.com

mv $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/orderers/orderer1.fabric.com/tls/keystore/*_sk $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/orderers/orderer1.fabric.com/tls/keystore/key.pem

# ------------------------------------------------------------------------------------------------------------------------
# Create The MSP directory for Orgs
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# On the orderer's host machine, we need to collect the MSPs for all the # organizations.
# ------------------------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------------------------
#The MSP for Org will contain
# 1. The trusted root certificate of Org,
# 2. The certificate of the Org's admin identity,
# 3. The trusted root certificate of the TLS CA.
# The MSP folder structure can be seen below.

#  /msp
#  ├── admincerts
#  │   └── admin-org-cert.pem
#  ├── cacerts
#  │   └── org-ca-cert.pem
#  ├── tlscacerts
#  │   └── tls-ca-cert.pem
#  └── users
# ---------------
# ------------------------------------------------------------------------------------------------------------------------
# Commands for gathering certificates
# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# The Fabric CA client has a couple commands that are useful in acquiring the certificates
    # for the orderer genesis and peer MSP setup.

    # The first command is the `fabric-ca-client certificate` command. This command can be used
    # to get certificates for the admincerts folder. For more information on how to use this command
    # , please refer to: `listing certificate information
    # <https://hyperledger-fabric-ca.readthedocs.io/en/latest/users-guide.html#listing-certificate-information>`__

    # The second command is the `fabric-ca-client getcainfo` command. This command can be used to gather
    # certificates for the `cacerts` and `tlscacerts` folders. The `getcainfo` command returns back the
    # certificate of the CA.
    # ---------------------------------------------------------------------------------------------------------
mkdir -p $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/msp/{cacerts,tlscacerts,admincerts}

  # ---------------------------------------------------
  # Orderer.org MSP
  # ---------------------------------------------------

  # cacerts --orderer
  export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/ca/ca.fabric.com-cert.pem
  export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/fabric.com/ca-admin
  fabric-ca-client getcacert -u https://0.0.0.0:7152 -M $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/msp

# Enroll Orderer's Admin ???
  export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/users/Admin@fabric.com/msp
  fabric-ca-client enroll -d -u https://Admin@fabric.com:ordereradminpw@0.0.0.0:7152

# AdminCerts --orderer
  fabric-ca-client identity list
  fabric-ca-client certificate list --id Admin@fabric.com --store $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/msp/admincerts

# tlscacerts --orderer
  export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/tlsca/tlsca.fabric.com-cert.pem
  export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/fabric.com/tlsca-admin
  fabric-ca-client getcacert -u https://0.0.0.0:7150 -M $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/msp --enrollment.profile tls

# OK

# delete keystore and signcerts empty dir

rm -rf $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/msp/{keystore,signcerts,user}

# OK

# ---------------------------------------------------
# Peer Org MSP
# ---------------------------------------------------

# cacerts --peer org
export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/ca/ca.po1.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/po1.fabric.com/ca-admin
fabric-ca-client getcainfo -u https://0.0.0.0:7153 -M $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/msp

# Enroll Peer's Admin
export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp
fabric-ca-client enroll -d -u https://Admin@po1.fabric.com:po1AdminPW@0.0.0.0:7153

# AdminCerts --peer org
fabric-ca-client identity list
fabric-ca-client certificate list --id Admin@po1.fabric.com --store $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/msp/admincerts

# tlscacerts --peer org
export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca/tlsca.po1.fabric.com-cert.pem
export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/po1.fabric.com/tlsca-admin
fabric-ca-client getcacert -u https://0.0.0.0:7151 -M $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/msp --enrollment.profile tls


# ------------------------------------------------------------------------------------------------------------------------
# Create Peer config.yaml
#
# cd ~/fabric01/rtr-fab-cr01
# Edit Configtx.yaml
# ------------------------------------------------------------------------------------------------------------------------

# nano $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/config.yaml

# NodeOUs:
#  Enable: true
#  ClientOUIdentifier:
#    Certificate: cacerts/0-0-0-0-7054.pem
#    OrganizationalUnitIdentifier: client
#  PeerOUIdentifier:
#    Certificate: cacerts/0-0-0-0-7054.pem
#    OrganizationalUnitIdentifier: peer

#set -x
#echo -e "
#NodeOUs:
#  Enable: true
#  ClientOUIdentifier:
#    Certificate: cacerts/0-0-0-0-7054.pem
#    OrganizationalUnitIdentifier: client
#  PeerOUIdentifier:
#    Certificate: cacerts/0-0-0-0-7054.pem
#    OrganizationalUnitIdentifier: peer
#" > $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/config.yaml

# ------------------------------------------------------------------------------------------------------------------------
# Create Genesis Block and Channel Transaction
#
# cd $FABRIC_CFG_PATH
# Edit Configtx.yaml
# ------------------------------------------------------------------------------------------------------------------------

#cd $FABRIC_CFG_PATH
# Create the orderer genesis block
#configtxgen -profile OneOrgsOrdererGenesis -channelID rtr-sys-channel -outputBlock $FABRIC_CFG_PATH/channel-artifacts/genesis.block
#configtxgen -inspectBlock ./channel-artifacts/genesis.block > logs/genesisblock.txt

# Create the channel
#export CHANNEL_NAME=fabchannel01
#configtxgen -profile OneOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
#configtxgen -inspectChannelCreateTx ./channel-artifacts/channel.tx > logs/channel.txt
# Defining anchor peers
#configtxgen -profile OneOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/po1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg po1MSP

#configtxgen -inspectChannelCreateTx ./channel-artifacts/channel.tx > logs/inspectchannel.txt

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
