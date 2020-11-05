#!/bin/bash

IP="192.168.1.20"
SUBJECT_CA="/C=PL/ST=Wroclove/L=Wroclove/O=damian/OU=CA/CN=$IP"

PORT=8070
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
CERTS_PATH=$CURRENT_DIR/certs
LOG_PATH=$CURRENT_DIR/logs
WWW_PATH=$CURRENT_DIR/www
SERVICES_PATH="/etc/systemd/system"

ARG0=$1

#TODO
# make shitch for generate scripts or install service or start service or stop service

main()
{
	echo "Arg1= $ARG0"
	echo "Current dir: $CURRENT_DIR"
	echo "Certificates dir: $CERTS_PATH"
	echo "Logs dir: $LOG_PATH"
	echo "WWW dir: $WWW_PATH"
	
	
	if [[ $ARG0 == "-s" ]]; then
		start_service
	elif [[ $ARG0 == "-i" ]]; then
		install_service
	elif [[ $ARG0 == "-crt" ]]; then
		generate_certs
	fi
}

generate_certs()
{
	./scripts/certs_gen.sh $SUBJECT_CA $CERTS_PATH
}

install_service()
{
	echo "Installing HTTPS OTA service for ESP32..."
	
	#TODO
	# check if ota.service already started
	# if not started then stop it and delete from systemds
	#if not started then delete it from systemd
	
	#TODO
	# allow firewall ports
	# sudo ufw allow from any to any port 8070 proto tcp

	# copy file

	echo "Copying service to $SERVICES_PATH ..."
	sudo cp -rf "scripts/ota.service" "$SERVICES_PATH/ota.service"
	
	echo "Service installed!"
}

start_service()
{
	echo "Starting HTTPS OTA service for ESP32... on port $PORT"

	(cd $WWW_PATH; openssl s_server -WWW -key $CERTS_PATH/ca_key.pem -cert $CERTS_PATH/ca_cert.pem -port $PORT 2>&1 | tee -a $LOG_PATH/ota.log)

	echo "Service started!"
}

main

exit