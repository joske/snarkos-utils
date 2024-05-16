#!/bin/bash
FAILED=()

if [ ! -f ~/.ssh/devnet/config ]; then
	echo "config file not found in ~/.ssh/devnet/config"
	exit 1
fi

CMD="sudo systemctl stop snarkos && sudo systemctl start snarkos"
REBOOT=0

NODES=$(grep 'Host ' "$HOME/.ssh/devnet/config" | awk '{print $2}' | xargs)
for arg in "$@"; do
	case $arg in
	-r)
		CMD="sudo reboot"
		REBOOT=1
		shift
		;;
	-v)
		NODES=$(grep 'Host ' "$HOME/.ssh/devnet/config" | grep -v client | awk '{print $2}' | xargs)
		shift
		;;
	-h)
		echo "Restart snarkos on all nodes in the devnet"
		echo
		echo "Usage: $0 [-r] [-v]"
		echo "  -h  display this help message"
		echo "  -r  reboot nodes"
		echo "  -v  restart validators only"
		exit 0
		;;
	esac
done

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
