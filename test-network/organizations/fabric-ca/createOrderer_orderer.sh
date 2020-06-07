#!/usr/bin/env bash
  mkdir -p /etc/hyperledger/example.com/orderers/example.com
#  mkdir -p /etc/hyperledger/example.com/orderers/orderer.example.com -> /var/hyperledger/orderer


  mkdir -p /etc/hyperledger/fabric-ca-server
  scp root@ca_orderer:/etc/hyperledger/fabric-ca-server/tls-cert.pem /etc/hyperledger/fabric-ca-server/

#  mkdir -p /etc/hyperledger/org1.example.com/msp/cacerts
#  scp root@ca_org1:/etc/hyperledger/org1.example.com/msp/cacerts/ca_org1-7054-ca_org1.pem /etc/hyperledger/org1.example.com/msp/cacerts/

mkdir /etc/hyperledger/example.com/msp/
  scp root@ca_orderer:/etc/hyperledger/example.com/msp/config.yaml /etc/hyperledger/example.com/msp/


  echo
  echo "## Generate the orderer msp"
  echo
  set -x
	fabric-ca-client enroll -u https://orderer:ordererpw@ca_orderer:9054 --caname ca_orderer -M /etc/hyperledger/orderer/msp --csr.hosts orderer.example.com --csr.hosts localhost --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

  cp /etc/hyperledger/example.com/msp/config.yaml /etc/hyperledger/orderer/msp/config.yaml

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