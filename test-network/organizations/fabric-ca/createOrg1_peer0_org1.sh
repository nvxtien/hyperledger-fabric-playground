#!/usr/bin/env bash


  echo "PEER0"

  echo "copy tls cert"

  mkdir -p /etc/hyperledger/fabric-ca-server
  scp root@ca_org1:/etc/hyperledger/fabric-ca-server/tls-cert.pem /etc/hyperledger/fabric-ca-server/

  mkdir -p /etc/hyperledger/org1.example.com/msp/cacerts
  scp root@ca_org1:/etc/hyperledger/org1.example.com/msp/cacerts/ca_org1-7054-ca_org1.pem /etc/hyperledger/org1.example.com/msp/cacerts/

  scp root@ca_org1:/etc/hyperledger/org1.example.com/msp/config.yaml /etc/hyperledger/org1.example.com/msp/

  mkdir -p /etc/hyperledger/org1.example.com/peers
  mkdir -p /etc/hyperledger/fabric

  echo
  echo "## Generate the peer0 msp"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@ca_org1:7054 --caname ca_org1 -M /etc/hyperledger/fabric/msp --csr.hosts peer0.org1.example.com --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

  cp /etc/hyperledger/org1.example.com/msp/config.yaml /etc/hyperledger/fabric/msp/config.yaml

  echo
  echo "## Generate the peer0-tls certificates"
  echo
  set -x
  fabric-ca-client enroll -u https://peer0:peer0pw@ca_org1:7054 --caname ca_org1 -M /etc/hyperledger/fabric/tls --enrollment.profile tls --csr.hosts peer0.org1.example.com --csr.hosts localhost --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x


  cp /etc/hyperledger/fabric/tls/tlscacerts/* /etc/hyperledger/fabric/tls/ca.crt
  cp /etc/hyperledger/fabric/tls/signcerts/* /etc/hyperledger/fabric/tls/server.crt
  cp /etc/hyperledger/fabric/tls/keystore/* /etc/hyperledger/fabric/tls/server.key

  mkdir /etc/hyperledger/org1.example.com/msp/tlscacerts
  cp /etc/hyperledger/fabric/tls/tlscacerts/* /etc/hyperledger/org1.example.com/msp/tlscacerts/ca.crt

  mkdir /etc/hyperledger/org1.example.com/tlsca
  cp /etc/hyperledger/fabric/tls/tlscacerts/* /etc/hyperledger/org1.example.com/tlsca/tlsca.org1.example.com-cert.pem

  mkdir /etc/hyperledger/org1.example.com/ca
  cp /etc/hyperledger/fabric/msp/cacerts/* /etc/hyperledger/org1.example.com/ca/ca.org1.example.com-cert.pem

  mkdir -p /etc/hyperledger/org1.example.com/users
  mkdir -p /etc/hyperledger/org1.example.com/users/User1@org1.example.com

  echo
  echo "## Generate the user msp"
  echo
  set -x
	fabric-ca-client enroll -u https://user1:user1pw@ca_org1:7054 --caname ca_org1 -M /etc/hyperledger/org1.example.com/users/User1@org1.example.com/msp --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

  mkdir -p /etc/hyperledger/org1.example.com/users/Admin@org1.example.com

  echo
  echo "## Generate the org admin msp"
  echo
  set -x
	fabric-ca-client enroll -u https://org1admin:org1adminpw@ca_org1:7054 --caname ca_org1 -M /etc/hyperledger/org1.example.com/users/Admin@org1.example.com/msp --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

  cp /etc/hyperledger/org1.example.com/msp/config.yaml /etc/hyperledger/org1.example.com/users/Admin@org1.example.com/msp/config.yaml


