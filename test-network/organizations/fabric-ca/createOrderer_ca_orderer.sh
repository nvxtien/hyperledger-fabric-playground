#!/usr/bin/env bash
  echo
	echo "Enroll the CA admin"
  echo
	mkdir -p /etc/hyperledger/example.com

	export FABRIC_CA_CLIENT_HOME=/etc/hyperledger/example.com

  set -x
  fabric-ca-client enroll -u https://admin:adminpw@ca_orderer:9054 --caname ca_orderer --tls.certfiles /etc/hyperledger/fabric-ca-server/tls-cert.pem
  set +x

  echo 'NodeOUs:
  Enable: true
  ClientOUIdentifier:
    Certificate: cacerts/ca_orderer-9054-ca_orderer.pem
    OrganizationalUnitIdentifier: client
  PeerOUIdentifier:
    Certificate: cacerts/ca_orderer-9054-ca_orderer.pem
    OrganizationalUnitIdentifier: peer
  AdminOUIdentifier:
    Certificate: cacerts/ca_orderer-9054-ca_orderer.pem
    OrganizationalUnitIdentifier: admin
  OrdererOUIdentifier:
    Certificate: cacerts/ca_orderer-9054-ca_orderer.pem
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