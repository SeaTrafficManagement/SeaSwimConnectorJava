#!/usr/bin/env bash
mc_certificate="mc-ca-chain.pem"
GeoTrust_Global_certificate="GeoTrust_Global_CA.pem"
lets_encrypt_certificate="lets-encrypt-x3-cross-signed.pem"
bimco_certificate="mc-bimco-cert.cer"
mc_id_reg_cert="mc-idreg-cert.cer"
mc_root_cert="mc-root-cert.cer"
mc_smart_cert="mc-smart-cert.cer"
mc_iala_cert="mc-iala-cert.cer"
jks_output_name="mc-truststore-password-is-changeit.jks"


keytool -import -v -trustcacerts -keystore ./keystores/$jks_output_name -storepass changeit -alias cacert1 -file ./certs/mc-certs/$mc_certificate
keytool -import -v -trustcacerts -keystore ./keystores/$jks_output_name -storepass changeit -alias cacert2 -file ./certs/mc-certs/$GeoTrust_Global_certificate
keytool -import -v -trustcacerts -keystore ./keystores/$jks_output_name -storepass changeit -alias cacert3 -file ./certs/mc-certs/$lets_encrypt_certificate
keytool -import -v -trustcacerts -keystore ./keystores/$jks_output_name -storepass changeit -alias cacert3 -file ./certs/mc-certs/$lets_encrypt_certificate
keytool -import -v -trustcacerts -keystore ./keystores/$jks_output_name -storepass changeit -alias cacert3 -file ./certs/mc-certs/$lets_encrypt_certificate

