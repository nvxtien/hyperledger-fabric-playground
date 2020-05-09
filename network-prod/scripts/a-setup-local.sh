#!/usr/bin/env bash
ssh-copy-id -i ~/.ssh/id_rsa.pub root@tls-ca
ssh-copy-id -i ~/.ssh/id_rsa.pub root@rca-org0
ssh-copy-id -i ~/.ssh/id_rsa.pub root@orderer1-org0
ssh-copy-id -i ~/.ssh/id_rsa.pub root@rca-org1
ssh-copy-id -i ~/.ssh/id_rsa.pub root@peer1-org1
ssh-copy-id -i ~/.ssh/id_rsa.pub root@peer2-org1