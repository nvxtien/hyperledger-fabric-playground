[//]: # (SPDX-License-Identifier: CC-BY-4.0)

## Start TLS CA   

  1. Create a docker-compose file for the CA TLS
  ```bash
  docker-compose-ca-tls.yaml
  ```
  2. Using kompose to convert the file docker-compose-ca-tls.yaml to files that you can use with kubectl
  ```bash
  $ mkdir export
  $ kompose -v convert -f docker-compose-ca-tls.yaml -o export
  ```
  There is a warning: Volume mount on the host "/tmp/hyperledger/tls-ca" isn't supported - ignoring path on the host.
  Local paths are not supported - Persistent Volume Claim should be created instead. (I currently ignore this step) 

  3. Now you can deploy your configuration to kubernetes cluster using:
  ```bash
  $ kubectl create -f export/
  ```
  Let's look at your service running.
  ```bash
  $ kubectl describe svc ca-tls
  ```
  You can get your pod's information.
  ```bash
  $ kubectl get po[pods]
  ```
  ```
  NAME                        READY     STATUS    RESTARTS   AGE
  po/ca-tls-166763502-b39x3   1/1       Running   0          14m
  ```
  On a successful launch of the pod, you will see the following line in the CA pod’s log by using the command.
  ```bash
  $ kubectl logs -f ca-tls-166763502-b39x3
  ```
  ```
  ...
  The certificate is at: /tmp/hyperledger/fabric-ca/crypto/ca-cert.pem
  ... 
  [INFO] Listening on http://0.0.0.0:7052
  ```
  You can take a look at the CA certificate that created.
  ```bash
  $ kubectl exec ca-tls-166763502-b39x3 -- cat /tmp/hyperledger/fabric-ca/crypto/ca-cert.pem
  ```
  
## Enroll TLS CA’s Admin
  In our example, you would need to acquire the file located at /tmp/hyperledger/tls/ca/crypto/ca-cert.pem on the 
machine running the TLS CA server and copy this file over to the host where you will be running the CA client binary.
  

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
