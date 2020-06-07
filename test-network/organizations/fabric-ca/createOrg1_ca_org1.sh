#!/usr/bin/env bash


  echo "Enroll the CA admin"
  mkdir -p /etc/hyperledger/org1.example.com/

  export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/org1.example.com/

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

  set +x
fabric-ca-client register --caname ca_org1 --id.name peer0 --id.secret peer0pw --id.type peer --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
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
