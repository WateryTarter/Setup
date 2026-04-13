#!/usr/bin/env bash

IPs=("172.24.19.44" "172.24.19.68" "172.24.19.82" "172.24.18.30" "172.24.21.12" "172.24.22.19" "172.24.10.180" "172.24.10.1" "172.24.19.1" "172.24.22.1")
USER="aliyev.sahrab"
URL="http://10.50.160.33/tmp/scripts/comb.sh"
PATH="/tmp/install.sh"

for target in "${IPs[@]}"; do
	echo "--- Starting Deployment to $target ---"
	ssh "$USER@$target" "wget -q $URL -O $PATH && \
		chmod +x $PATH && \
		./$PATH" 2> /tmp/remote_error.log && \
		rm "$PATH"

	if [ $? -ne 0 ]; then
		echo "FAILED: Stopped at $target"
		echo "Error details: "
		cat "/tmp/remote_error.log"
		exit 1
	fi

	echo "SUCCESS: $target"
	echo ""
done

