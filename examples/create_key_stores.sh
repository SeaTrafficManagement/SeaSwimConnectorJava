#!/usr/bin/env bash
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
