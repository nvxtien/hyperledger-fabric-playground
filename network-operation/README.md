[//]: # (SPDX-License-Identifier: CC-BY-4.0)

## Add a New Organization to Hyperledger Fabric Channel

1. First, you are in the add-ord directory then use the following command:
```bash
$ ./fabcar/startFabric.sh 
``` 
Please wait a few minutes for the network started up. You can take a look at what nodes are running:
```bash
$ docker ps -a
```

2. After the network started, you run the script below to add a new organization:
```bash
# ./first-network/eyfn.sh up -c [channel] -s [world state] -i [images version] -d [delay time]
$ ./first-network/eyfn.sh up -c mychannel -s couchdb -i 1.4.3 -d 6
```

## Upgrade Your Chaincode

3. Execute the command like this to upgrade your chaincode:
```bash
$ ./first-network/upgrade.sh upgrade -c mychannel -e 3.0
``` 

## License <a name="license"></a>

Hyperledger Fabric Playground source code files are made available under the Apache
License, Version 2.0 (Apache-2.0), located in the [LICENSE](LICENSE) file.
Hyperledger Project documentation files are made available under the Creative
Commons Attribution 4.0 International License (CC-BY-4.0), available at http://creativecommons.org/licenses/by/4.0/.
