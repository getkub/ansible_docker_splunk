#!/bin/sh

thisDir=`pwd`
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cert_dir="/tmp/temp_certs/CORE_all_certs/bin/auth"
rm -rf $cert_dir
mkdir -p $cert_dir && cd $cert_dir
pass=changedme

# ================================================= #
# rootCA
# Generate a private key for your root certificate
openssl genrsa -aes256 -out rootCA.key -passout pass:$pass 2048

#Generate and sign the certificate
openssl req -new -config ${SCRIPT_DIR}/certs.cfg -key rootCA.key -passin pass:$pass -out rootCA.csr

# generate the public certificate:
openssl x509 -req -in rootCA.csr -sha512 -signkey rootCA.key -passin pass:$pass -CAcreateserial -out rootCA.pem -days 1095
# ================================================= #

# ================================================= #
# Server Certificate
#Generate a key for your server certificate
openssl genrsa -aes256 -out device.key -passout pass:$pass 2048

#Generate server certificate
openssl req -new -config ${SCRIPT_DIR}/certs.cfg -key device.key -passin pass:$pass -out device.csr

# User Server.csr  rootCA to generate server certificate
openssl x509 -req -in device.csr -SHA256 -CA rootCA.pem -CAkey rootCA.key -CAcreateserial -passin pass:$pass -out device.pem -days 1095
# ================================================= #

cd $thisDir