

function createOrg1 {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p /etc/hyperledger/org1.example.com/

	export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/org1.example.com/
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@ca_org1:7054 --caname ca_org1 --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/ca_org1-7054-ca_org1.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/ca_org1-7054-ca_org1.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/ca_org1-7054-ca_org1.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/ca_org1-7054-ca_org1.pem
    OrganizationalUnitIdentifier: orderer' > /etc/hyperledger/org1.example.com/msp/config.yaml

  echo
	echo "Register peer0"
  echo
  set -x
	fabric-ca-client register --caname ca_org1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

  echo
  echo "Register user"
  echo
  set -x
  fabric-ca-client register --caname ca_org1 --id.name user1 --id.secret user1pw --id.type client --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

  echo
  echo "Register the org admin"
  echo
  set -x
  fabric-ca-client register --caname ca_org1 --id.name org1admin --id.secret org1adminpw --id.type admin --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

  echo "PEER0"

  mkdir -p etc/hyperledger/org1.example.com/peers
  mkdir -p etc/hyperledger/org1.example.com/peers/peer0.org1.example.com

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@ca_org1:7054 --caname ca_org1 -M /etc/hyperledger/org1.example.com/peers/peer0.org1.example.com/msp --csr.hosts peer0.org1.example.com --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

  cp /etc/hyperledger/org1.example.com/msp/config.yaml /etc/hyperledger/org1.example.com/peers/peer0.org1.example.com/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@ca_org1:7054 --caname ca_org1 -M /etc/hyperledger/org1.example.com/peers/peer0.org1.example.com/tls --enrollment.profile tls --csr.hosts peer0.org1.example.com --csr.hosts localhost --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x


  cp /etc/hyperledger/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* /etc/hyperledger/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt
  cp /etc/hyperledger/org1.example.com/peers/peer0.org1.example.com/tls/signcerts/* /etc/hyperledger/org1.example.com/peers/peer0.org1.example.com/tls/server.crt
  cp /etc/hyperledger/org1.example.com/peers/peer0.org1.example.com/tls/keystore/* /etc/hyperledger/org1.example.com/peers/peer0.org1.example.com/tls/server.key

  mkdir /etc/hyperledger/org1.example.com/msp/tlscacerts
  cp /etc/hyperledger/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* /etc/hyperledger/org1.example.com/msp/tlscacerts/ca.crt

  mkdir /etc/hyperledger/org1.example.com/tlsca
  cp /etc/hyperledger/org1.example.com/peers/peer0.org1.example.com/tls/tlscacerts/* /etc/hyperledger/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem

  mkdir /etc/hyperledger/org1.example.com/ca
  cp /etc/hyperledger/org1.example.com/peers/peer0.org1.example.com/msp/cacerts/* /etc/hyperledger/org1.example.com/ca/ca.org1.example.com-cert.pem

  mkdir -p /etc/hyperledger/org1.example.com/users
  mkdir -p /etc/hyperledger/org1.example.com/users/User1@org1.example.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@localhost:7054 --caname ca_org1 -M /etc/hyperledger/org1.example.com/users/User1@org1.example.com/msp --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

  mkdir -p /etc/hyperledger/org1.example.com/users/Admin@org1.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://org1admin:org1adminpw@localhost:7054 --caname ca_org1 -M /etc/hyperledger/org1.example.com/users/Admin@org1.example.com/msp --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

  cp /etc/hyperledger/org1.example.com/msp/config.yaml /etc/hyperledger/org1.example.com/users/Admin@org1.example.com/msp/config.yaml

}


function createOrderer {

  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p /etc/hyperledger/example.com

	export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/example.com
#  rm -rf $FABRIC_CA_CLIENT_HOME/fabric-ca-client-config.yaml
#  rm -rf $FABRIC_CA_CLIENT_HOME/msp

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@ca_orderer:9054 --caname ca_orderer --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/localhost-9054-ca_orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/localhost-9054-ca_orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/localhost-9054-ca_orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/localhost-9054-ca_orderer.pem
    OrganizationalUnitIdentifier: orderer' > /etc/hyperledger/example.com/msp/config.yaml


  echo
	echo "Register orderer"
  echo
  set -x
	fabric-ca-client register --caname ca_orderer --id.name orderer --id.secret ordererpw --id.type orderer --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
    set +x

  echo
  echo "Register the orderer admin"
  echo
  set -x
  fabric-ca-client register --caname ca_orderer --id.name ordererAdmin --id.secret ordererAdminpw --id.type admin --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

	mkdir -p /etc/hyperledger/example.com/orderers
  mkdir -p /etc/hyperledger/example.com/orderers/example.com

  mkdir -p /etc/hyperledger/example.com/orderers/orderer.example.com

  echo
  echo "## Generate the orderer msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orderer:ordererpw@ca_orderer:9054 --caname ca_orderer -M /etc/hyperledger/orderer/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

  cp /etc/hyperledger//example.com/msp/config.yaml /etc/hyperledger/orderer/msp/config.yaml

  echo
  echo "## Generate the orderer-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://orderer:ordererpw@ca_orderer:9054 --caname ca_orderer -M /etc/hyperledger/orderer/tls --enrollment.profile tls --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

  cp /etc/hyperledger/orderer/tls/tlscacerts/* /etc/hyperledger/orderer/tls/ca.crt
  cp /etc/hyperledger/orderer/tls/signcerts/* /etc/hyperledger/orderer/tls/server.crt
  cp /etc/hyperledger/orderer/tls/keystore/* /etc/hyperledger/orderer/tls/server.key

  mkdir /etc/hyperledger/orderer/msp/tlscacerts
  cp /etc/hyperledger/orderer/tls/tlscacerts/* /etc/hyperledger/orderer/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir /etc/hyperledger/example.com/msp/tlscacerts
  cp /etc/hyperledger/orderer/tls/tlscacerts/* /etc/hyperledger/example.com/msp/tlscacerts/tlsca.example.com-cert.pem

  mkdir -p /etc/hyperledger/example.com/users
  mkdir -p /etc/hyperledger/example.com/users/Admin@example.com

  echo
  echo "## Generate the admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://ordererAdmin:ordererAdminpw@ca_orderer:9054 --caname ca_orderer -M /etc/hyperledger/example.com/users/Admin@example.com/msp --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

  cp /etc/hyperledger/example.com/msp/config.yaml /etc/hyperledger/example.com/users/Admin@example.com/msp/config.yaml


}
