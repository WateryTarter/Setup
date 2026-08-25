#!/usr/bin/env bash

IPs=("172.24.19.44" "172.24.19.68" "172.24.21.12" "172.24.22.19" "172.24.10.180" "172.24.10.1" "172.24.19.1" "172.24.22.1")
USER="putyourusernamehere"
URL="http://10.50.160.33:8000/scriptnamegoeshere"
L_PATH="/tmp/install.sh"

for target in "${IPs[@]}"; do
	echo "--- Starting Deployment to $target ---"
	if [[ $target == *.1 ]]; then
		ssh "$USER@$target" -p 20222 "wget -q $URL -O $L_PATH && \
			chmod +x $L_PATH && \
			sudo $L_PATH && rm $L_PATH" 2> /tmp/remote_error.log
	else
		ssh "$USER@$target" "wget -q $URL -O $L_PATH && \
			chmod +x $L_PATH && \
			sudo $L_PATH && rm $L_PATH" 2> /tmp/remote_error.log
	fi

	if [ $? -ne 0 ]; then
		echo "FAILED: Stopped at $target"
		echo "Error details: "
		cat "/tmp/remote_error.log"
		exit 1
	fi

	echo "SUCCESS: $target"
	echo ""
done

