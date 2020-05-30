#!/bin/sh
echo
echo " ____    _____      _      ____    _____ "
echo "/ ___|  |_   _|    / \    |  _ \  |_   _|"
echo "\___ \    | |     / _ \   | |_) |   | |  "
echo " ___) |   | |    / ___ \  |  _ <    | |  "
echo "|____/    |_|   /_/   \_\ |_| \_\   |_|  "
echo
echo "Define by Tien"
echo

cd $HOME

echo "------------------------------------------------------------------------------------------------------"
echo "# After enrollment, you should have an admin MSP. "
echo "# You will copy the certificate from this MSP and move it to the Peer1's MSP in the ``admincerts``"
echo "# folder. You will need to disseminate this admin certificate to other peers in the"
echo "# org, and it will need to go in to the ``admincerts`` folder of each peers' MSP."
echo "------------------------------------------------------------------------------------------------------"

set -x
echo "peer1.po1.fabric.com"
cp -R /etc/hyperledger/po1.fabric.com/users/admin@po1.fabric.com/msp/admincerts /etc/hyperledger/po1.fabric.com/peers/peer1.po1.fabric.com/msp/

scp /etc/hyperledger/po1.fabric.com/peers/peer1.po1.fabric.com/msp/admincerts/admin@po1.fabric.com.pem root@peer0.po1.fabric.com:/etc/hyperledger/po1.fabric.com/peers/peer0.po1.fabric.com/msp/admincerts/

cp -R /etc/hyperledger/po1.fabric.com/users/admin@po1.fabric.com/msp/signcerts/cert.pem /etc/hyperledger/po1.fabric.com/peers/peer1.po1.fabric.com/msp/admincerts/

scp /etc/hyperledger/po1.fabric.com/peers/peer1.po1.fabric.com/msp/signcerts/cert.pem root@peer0.po1.fabric.com:/etc/hyperledger/po1.fabric.com/peers/peer0.po1.fabric.com/msp/admincerts/

#rm /etc/hyperledger/po1.fabric.com/peers/peer0.po1.fabric.com/msp/admincerts/admin@po1.fabric.com.pem
#rm /etc/hyperledger/po1.fabric.com/peers/peer1.po1.fabric.com/msp/admincerts/admin@po1.fabric.com.pem
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
