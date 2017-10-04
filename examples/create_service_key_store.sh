#!/usr/bin/env bash
privatekey_name="PrivateKey_VIS_Service_001.pem"
cert_name="Certificate_VIS_Service_001.pem"
servicename="vis001"
mc_ca_chain_name="mc-ca-chain.pem"


# create the p12
openssl pkcs12 -export -in ./certs/service-certs/$cert_name -inkey ./certs/service-certs/$privatekey_name -certfile  certs/mc-certs/$mc_ca_chain_name -name $servicename -out ./p12/$servicename.p12

# create keystore
echo "Enter p12 password again, the same password will be used for the keystore"
read p12password
keystore_deststorepass=$p12password
keystore_destkeypass=$p12password
keytool -importkeystore -deststorepass $keystore_deststorepass -destkeypass $keystore_destkeypass -destkeystore ./keystores/$servicename.jks -srckeystore ./p12/$servicename.p12 -srcstoretype PKCS12 -srcstorepass $p12password -alias $servicename
