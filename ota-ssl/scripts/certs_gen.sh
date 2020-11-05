#!/bin/bash

SUBJECT_CA=$1
CERTS_PATH=$2

generate_CA(){
	echo "Generating CA key for subject: $SUBJECT_CA"
	echo "Certs path: $CERTS_PATH"
	openssl req -x509 -newkey rsa:2048 -keyout $CERTS_PATH/ca_key.pem -out $CERTS_PATH/ca_cert.pem -days 365 -nodes -subj "$SUBJECT_CA"
}

copy_keys_to_ota_service(){
	sudo cp ca_key.pem
}

generate_CA