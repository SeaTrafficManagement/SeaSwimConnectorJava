Start the SSC
=============

In order to run the SSC is need to prepare the system to do it. 
- create the keystores: Java use keystores that contains the information relatives to the certificates 
- setup the configuration file 
- run the application


create the key Store
--------------------

Given the certificates included in this folder, this document will guide you the process for the creation of the keystores needed by the SSC applications (seaswim-connector and ssc-client).

- you can use this script

```bash
#!/usr/bin/env bash

## change the values with the rigth name
privatekey_name="PrivateKey_viscimne1.pem"
cert_name="Certificate_viscimne1.pem"
servicename="viscimne1"

# create the p12
openssl pkcs12 -export -in ./certs/service-certs/$cert_name -inkey ./certs/service-certs/$privatekey_name -certfile  certs/mc-certs/mc-ca-chain.pem -name $servicename -out ./p12/$servicename.p12

# create keystore
echo "Enter p12 password again, the same password will be used for the keystore"
read p12password
keystore_deststorepass=$p12password
keystore_destkeypass=$p12password
keytool -importkeystore -deststorepass $keystore_deststorepass -destkeypass $keystore_destkeypass -destkeystore ./keystores/$servicename.jks -srckeystore ./p12/$servicename.p12 -srcstoretype PKCS12 -srcstorepass $p12password -alias $servicename

```

set-up the application-properties
---------------------------------
Is need to define the parameters adapted to the desired deployment. 
The follow example used by "mySuperService"
* MySuperService expose a REST Full Api 
    * API-MySuperService run on private network **127.0.0.1:5002**
    * SSC-Public-MySuperService listen incoming calls on public network  **0.0.0.0:8000**
    * SSC-Private-MySuperService expose the SSC functionality on the private network **127.0.0.1:8001**
* This example use the Maritime Cloud Test Environment

```properties
#Identity Registry using Certificates base path (URL)
stm.identityRegistry.x509.url=https://test-api-x509.maritimecloud.net/x509/api

#Identity Registry using OpenId Connect base path (URL)
stm.identityRegistry.oidc.url=https://test-api.maritimecloud.net/oidc/api

#Service Registry base path
stm.serviceRegistry.url=https://sr-test.maritimecloud.net/api

#OPENID-CONNECT urls
stm.identityRegistry.openid.auth=https://test-maritimeid.maritimecloud.net/auth/realms/MaritimeCloud/protocol/openid-connect/auth?
stm.identityRegistry.openid.token=https://test-maritimeid.maritimecloud.net/auth/realms/MaritimeCloud/protocol/openid-connect/token?

#logging.level.org.springframework= DEBUG
#logging.level.org.apache.http=DEBUG
#logging.level.org.springframework= DEBUG


# SSC configuration server1
connector.name=${name:ssc-mysuperservice}

# properties for application server's configuration

# enables 2-way SSL authentication
server.ssl.client-auth=need

## KEYSTORE SETTINGS ##
# keystore (private key) location
server.ssl.key-store=file:keystores/viscimne1.jks

# keystore password
server.ssl.key-store-password=cimnessc

# private key password p12
server.ssl.key-password=cimnessc

## TRUSTSTORE SETTINGS - trusted certificates ##
# truststore (trusted certificates) location
server.ssl.trust-store=file:keystores/mc-truststore.jks

#truststore password
server.ssl.trust-store-password=changeit

## OPEN ID CONNECT CONFIGURATION ##
#redirectPort must begin with 9 (IdentityRegistry requirement)
openid.redirectPort=9991

#redirectURI must begin with http://localhost:9 (IdentityRegistry requirement)
opeind.redirectURI=http://localhost:${openid.redirectPort}/openid/auth


## SSC PORTS CONFIGURATION ##
##  |VISCIMNE1:5001| <-- forwarded_to -- |SSC:8001| <-- incoming calls
##  |VISCIMNE1:5001| --> use private ssc |SSC:7001| --> outGoing calls 
# SSC listening Proxy port
server.port=8001

# SSC Private interface
privateAPI.port=7001

# SSC private interface use HTTP
privateAPI.secure=false

# configuration of the service associated to the SSC - the VIS1
service.endpoint=http://localhost:5001
```


run the seaSwimConnector
------------------------

The file application.properties contain the SSC configuration. When the SSC is launched without any parameter the program check for the application property in the same directory. 
Run the SSC server with custom properties in the same rootpath 
``` bash
  java  -jar seaswim-connector-0.0.2.jar 
```

