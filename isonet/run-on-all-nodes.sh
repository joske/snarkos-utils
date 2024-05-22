#!/bin/bash
FAILED=()

if [ ! -f ~/.ssh/devnet/config ]; then
	echo "config file not found in ~/.ssh/devnet/config"
	exit 1
fi

function usage() {
	echo "Run a command on all nodes in the devnet"
	echo
	echo "Usage: $0 [-v] [-d delay] <command>"
	echo "  -h  display this help message"
	echo "	-d  delay between running on validators (default 30s)"
	echo "  -v  validators only"
}

NODES=$(grep 'Host ' "$HOME/.ssh/devnet/config" | awk '{print $2}' | xargs)
DELAY=30

for arg in "$@"; do
	case $arg in
	-d)
		DELAY=$arg
		shift
		;;
	-v)
		NODES=$(grep 'Host ' "$HOME/.ssh/devnet/config" | grep -v client | awk '{print $2}' | xargs)
		shift
		;;
	-h)
		usage
		exit 0
		;;
	esac
done

if [ $# -ne 1 ]; then
	usage
	exit 1
fi

CMD="$1"

for n in $NODES; do
	echo "running \"$CMD\" on $n"
	ssh -F ~/.ssh/devnet/config -i ~/.ssh/devnet/devnet-key -o StrictHostKeyChecking=no -o ConnectTimeout=2 "$n" "$CMD"
	if [ $? -ne 0 ]; then
		echo -e "\e[0;31mfailed to run on $n\e[0m"
		FAILED+=("$n")
	else
		if [[ "$n" == *client* ]]; then
			echo "ran on client $n"
		else
			echo "ran on validator $n"
			sleep $DELAY
		fi
	fi
	echo
done

echo Failed nodes: "${FAILED[@]}"
