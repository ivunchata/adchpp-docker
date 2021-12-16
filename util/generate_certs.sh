#!/bin/bash

echo "Checking for OpenSSL"

if [ "$(which openssl)" ];
        then
        echo "OpenSSL was found, generating keys..."
        openssl genrsa -out privkey.pem 2048

        openssl dhparam -outform PEM -out dhparam.pem 2048

        openssl req -new -x509 -key privkey.pem -out cacert.pem -days 3650 -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=example.com"

        mkdir -p certs/trusted

        mv *.pem certs

        echo "All done!"
else
        echo "Unable to locate OpenSSL, please make sure it is installed"
fi
