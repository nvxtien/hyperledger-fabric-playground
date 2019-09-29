[//]: # (SPDX-License-Identifier: CC-BY-4.0)

## Topology
  
  - one organization with two peers
  - one orderer
  - two TLS CA servers 
  - two CA Servers, one CA each for peer org and orderer org

##

  ```bash
  $ docker network create --driver bridge fab-net
  ```  
## Setup TLS CA   

  $ mkdir -p $FABRIC_CFG_PATH/fabca/fabric.com/{ca-admin,ca-server,tlsca-admin,tlsca-server}
  $ mkdir -p $FABRIC_CFG_PATH/fabca/po1.fabric.com/{ca-admin,ca-server,tlsca-admin,tlsca-server}
  
  
  $ mkdir -p $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca
  $ mkdir -p $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/tlsca
  
  $ cd $FABRIC_CFG_PATH
  
  $ cp $FABRIC_CFG_PATH/fabca/fabric.com/tlsca-server/msp/keystore/*_sk  $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/tlsca/
  $ cp $FABRIC_CFG_PATH/fabca/po1.fabric.com/tlsca-server/msp/keystore/*_sk  $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca/
  
  
  # ------------------------------------------------------------------------------------------------------
  # Register orderer identities with the tls-ca-orderer
  # ------------------------------------------------------------------------------------------------------
  export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/tlsca/tlsca.fabric.com-cert.pem
  export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/fabric.com/tlsca-admin
  
  fabric-ca-client enroll -d -u https://tls-ord-admin:tls-ord-adminpw@0.0.0.0:7150
    
  fabric-ca-client register -d --id.name orderer1.fabric.com --id.secret ordererPW --id.type orderer -u https://0.0.0.0:7150
  
  fabric-ca-client register -d --id.name Admin@fabric.com --id.secret ordereradminpw --id.type admin -u https://0.0.0.0:7150
    
  # 111 
    
  # ------------------------------------------------------------------------------------------------------
  # Register peer identities with the tls-ca-peer
  # ------------------------------------------------------------------------------------------------------
  
  export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca/tlsca.po1.fabric.com-cert.pem
  export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/po1.fabric.com/tlsca-admin
  
  fabric-ca-client enroll -d -u https://tls-peer-admin:tls-peer-adminpw@0.0.0.0:7151
  fabric-ca-client register -d --id.name peer0.po1.fabric.com --id.secret peer0PW --id.type peer -u https://0.0.0.0:7151
  fabric-ca-client register -d --id.name peer1.po1.fabric.com --id.secret peer0PW --id.type peer -u https://0.0.0.0:7151
  fabric-ca-client register -d --id.name Admin@po1.fabric.com --id.secret po1AdminPW --id.type admin -u https://0.0.0.0:7151
  
  # 222
  
  # ------------------------------------------------------------------------------------------------------
  # Setup orderer CA
  # Each organization must have it's own Certificate Authority (CA) for issuing enrollment certificates.
  # ------------------------------------------------------------------------------------------------------
      
  docker-compose -f docker-compose-rca.yaml up
  docker-compose -f docker-compose-rca.yaml down
  
  docker-compose -f docker-compose-rca.yaml up ca.fabric.com
  docker-compose -f docker-compose-rca.yaml up ca.po1.fabric.com
  
  
  #$ cp ./fabca/fabric.com/tlsca-server/msp/keystore/*_sk  ./crypto-config/ordererOrganizations/fabric.com/tlsca/
  #$ cp ./fabca/po1.fabric.com/tlsca-server/msp/keystore/*_sk  ./crypto-config/peerOrganizations/po1.fabric.com/tlsca/
  
  #cp 757391ada3e_sk /home/hyper/fabric/crypto-config/peerOrganizations/po1.fabric.com/ca
  #cp 5d96720f_sk  /home/hyper/fabric/crypto-config/ordererOrganizations/fabric.com/ca
  
  
  export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/ca/ca.fabric.com-cert.pem
  export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/fabric.com/ca-admin
  
  fabric-ca-client enroll -d -u https://rca-orderer-admin:rca-orderer-adminpw@0.0.0.0:7152
  fabric-ca-client register -d --id.name orderer1.fabric.com --id.secret ordererpw --id.type orderer -u https://0.0.0.0:7152
  fabric-ca-client register -d --id.name Admin@fabric.com --id.secret ordereradminpw --id.type admin --id.attrs "hf.Registrar.Roles=client,hf.Registrar.Attributes=*,hf.Revoker=true,hf.GenCRL=true,admin=true:ecert,abac.init=true:ecert" -u https://0.0.0.0:7152
  
  # 333
  
  # ------------------------------------------------------------------------------------------------------
  # Setup peer CA
  # ------------------------------------------------------------------------------------------------------	
  
  
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
  
  
  
  
  fabric-ca-client identity list
  # ------------------------------------------------------------------------------------------------------
  # Enroll peers with the CA 
  # Before starting up a peer, enroll the peer identities with the CA to get the MSP that the peer will use.
  # This is known as the local peer MSP.
  # ------------------------------------------------------------------------------------------------------
  
  export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/ca/ca.po1.fabric.com-cert.pem
  export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/po1.fabric.com/ca-admin
  
  #peer0
  export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp
  fabric-ca-client enroll -d -u https://peer0.po1.fabric.com:peer1PW@0.0.0.0:7153 --csr.hosts peer0.po1.fabric.com
  
  #peer1
  export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/msp 
  fabric-ca-client enroll -d -u https://peer1.po1.fabric.com:peer2PW@0.0.0.0:7153 --csr.hosts peer1.po1.fabric.com
  
  
  
  # ------------------------------------------------------------------------------------------------------
  # Enroll and Get the TLS cryptographic material for the peer. 
  # This requires another enrollment,
  # Enroll against the ``tls`` profile on the TLS CA. 
  #Copy TLS CA from TLS if on another server.
  
  # cp $FABRIC_CFG_PATH/tls-rca/po1.fabric.com/tls/ca/server/tls-cert.pem $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca
  export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca/tlsca.po1.fabric.com-cert.pem
  export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/po1.fabric.com/tlsca-admin
  
  export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/tls
  fabric-ca-client enroll -d -u https://peer0.po1.fabric.com:peer0PW@0.0.0.0:7151 --enrollment.profile tls --csr.hosts peer0.po1.fabric.com
  
  export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer1.po1.fabric.com/tls
  fabric-ca-client enroll -d -u https://peer1.po1.fabric.com:peer0PW@0.0.0.0:7151 --enrollment.profile tls --csr.hosts peer1.po1.fabric.com
  
  # rename keystore = key.pem
  
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
  
  # AdminCerts
  fabric-ca-client identity list
  fabric-ca-client certificate list --id Admin@po1.fabric.com --store $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/admincerts
  
  
  
  # --------------------------------------------------------------
  # Enroll user
  export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/User1@po1.fabric.com/msp
  fabric-ca-client enroll -d -u https://User1@po1.fabric.com:po1UserPW@0.0.0.0:7153
  
  # After enrollment, you should have an admin MSP. 
  # You will copy the certificate from this MSP and move it to the Peer1's MSP in the ``admincerts``
  # folder. You will need to disseminate this admin certificate to other peers in the
  # org, and it will need to go in to the ``admincerts`` folder of each peers' MSP.
  
  # --------------------------------------------------------------
  # Alternate Method manual copy
  mkdir $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/admincerts
  cp $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/msp/signcerts/cert.pem $FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/peers/peer0.po1.fabric.com/msp/admincerts
  
  
  
  # --------------------------------------------------------------
  # Enroll and Get the TLS cryptographic material for the Admin User
  ## Enroll against the ``tls`` profile on the TLS CA. Using Tls cert.
  
  export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/tlsca/tlsca.po1.fabric.com-cert.pem
  export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/po1.fabric.com/tlsca-admin
  
  export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/peerOrganizations/po1.fabric.com/users/Admin@po1.fabric.com/tls
  fabric-ca-client enroll -d -u https://Admin@po1.fabric.com:po1AdminPW@0.0.0.0:7151 --enrollment.profile tls 
  
  # ------------------------------------------------------------------------------------------------------
  # Launch Org1's Peers
  # ------------------------------------------------------------------------------------------------------
  
  #peer1-org1.yaml
  #cd $FABRIC_CFG_PATH/scripts
  #docker-compose -f peer0-po1.yaml up
  #docker-compose -f peer0-po1.yaml down
  
  docker-compose -f docker-compose-cli.yaml up peer0.po1.fabric.com
  
  
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
  cp $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/users/Admin@fabric.com/msp/admincerts/*.pem $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/orderers/orderer1.fabric.com/msp/admincerts/
  
  # 2019/09/28 13:24:56 [INFO] Stored client certificate at $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/users/Admin@fabric.com/tls/signcerts/cert.pem
  # 2019/09/28 13:24:56 [INFO] Stored TLS root CA certificate at $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/users/Admin@fabric.com/tls/tlscacerts/tls-0-0-0-0-7150.pem
  
  # renane keystore _sk = key.pem
  
  # --------------------------------------------------------------------------------
  # Orderer TLS certificate.
  
  export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/tlsca/tlsca.fabric.com-cert.pem
  export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/fabric.com/tlsca-admin
  export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/orderers/orderer1.fabric.com/tls
  fabric-ca-client enroll -d -u https://orderer1.fabric.com:ordererPW@0.0.0.0:7150 --enrollment.profile tls --csr.hosts orderer1.fabric.com
  
  
  export FABRIC_CA_CLIENT_MSPDIR=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/users/Admin@fabric.com/tls
  fabric-ca-client enroll -d -u https://Admin@fabric.com:ordereradminpw@0.0.0.0:7150 --enrollment.profile tls --csr.hosts orderer1.fabric.com
  
  # rename keystore -sk= key.pem
  
  
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
  
    /msp
    ├── admincerts
    │   └── admin-org-cert.pem
    ├── cacerts
    │   └── org-ca-cert.pem
    ├── tlscacerts
    │   └── tls-ca-cert.pem
    └── users
    
    
    
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
    ---------------------------------------------------------------------------------------------------------
    mkdir -p msp/{cacerts,tlscacerts,admincerts}
    
  
  # ---------------------------------------------------
  # Orderer.org MSP
  # ---------------------------------------------------
  
  # cacerts --orderer
  export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/ca/ca.fabric.com-cert.pem
  export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/fabric.com/ca-admin
  fabric-ca-client getcacert -u https://0.0.0.0:7152 -M $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/msp
  
  # AdminCerts --orderer
  fabric-ca-client identity list
  fabric-ca-client certificate list --id Admin@fabric.com --store $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/msp/admincerts
  
  # tlscacerts --orderer
  export FABRIC_CA_CLIENT_TLS_CERTFILES=$FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/tlsca/tlsca.fabric.com-cert.pem
  export FABRIC_CA_CLIENT_HOME=$FABRIC_CFG_PATH/fabca/fabric.com/tlsca-admin
  fabric-ca-client getcacert -u https://0.0.0.0:7150 -M $FABRIC_CFG_PATH/crypto-config/ordererOrganizations/fabric.com/msp --enrollment.profile tls
  
  
## License <a name="license"></a>

Hyperledger Fabric Playground source code files are made available under the Apache
License, Version 2.0 (Apache-2.0), located in the [LICENSE](LICENSE) file.
Hyperledger Project documentation files are made available under the Creative
Commons Attribution 4.0 International License (CC-BY-4.0), available at http://creativecommons.org/licenses/by/4.0/.
