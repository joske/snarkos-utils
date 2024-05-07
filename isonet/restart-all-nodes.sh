#!/bin/bash

NODES="snarkos-node-0 snarkos-client-node-group-0-0 snarkos-client-node-group-0-1 snarkos-client-node-group-0-2 snarkos-node-1 snarkos-client-node-group-1-0 snarkos-client-node-group-1-1 snarkos-client-node-group-1-2 snarkos-node-2 snarkos-client-node-group-2-0 snarkos-client-node-group-2-1 snarkos-client-node-group-2-2 snarkos-node-3 snarkos-client-node-group-3-0 snarkos-client-node-group-3-1 snarkos-client-node-group-3-2 snarkos-node-4 snarkos-client-node-group-4-0 snarkos-client-node-group-4-1 snarkos-client-node-group-4-2 snarkos-node-5 snarkos-client-node-group-5-0 snarkos-client-node-group-5-1 snarkos-client-node-group-5-2 snarkos-node-6 snarkos-client-node-group-6-0 snarkos-client-node-group-6-1 snarkos-client-node-group-6-2 snarkos-node-7 snarkos-client-node-group-7-0 snarkos-client-node-group-7-1 snarkos-client-node-group-7-2 snarkos-node-8 snarkos-client-node-group-8-0 snarkos-client-node-group-8-1 snarkos-client-node-group-8-2 snarkos-node-9 snarkos-client-node-group-9-0 snarkos-client-node-group-9-1 snarkos-client-node-group-9-2"
# NODES="localhost"
FAILED=()

if [ ! -f ~/.ssh/devnet/config ]; then
	echo "config file not found in ~/.ssh/devnet/config"
	exit 1
fi

CMD="sudo systemctl stop snarkos && sudo systemctl start snarkos"
REBOOT=0

if [ "$1" == "-r" ]; then
	CMD="sudo reboot"
	REBOOT=1
fi

for n in $NODES; do
	echo "restart $n"
	ssh -F ~/.ssh/devnet/config -i ~/.ssh/devnet/devnet-key -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$n" "$CMD"
	if [ $REBOOT != 1 ]; then
		# no point in checking the return code if we're rebooting
		echo
		continue
	fi
	if [ $? -ne 0 ]; then
		echo -e "\e[0;31mfailed to restart $n\e[0m"
		FAILED+=("$n")
	else
		echo "restarted $n"
	fi
	echo
done

echo Failed nodes: "${FAILED[@]}"
