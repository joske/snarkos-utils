#!/bin/bash

if [ ! -f ~/.ssh/devnet/config ]; then
	echo "config file not found in ~/.ssh/devnet/config"
	exit 1
fi

function usage() {
	echo "Copy file to all nodes in the devnet"
	echo
	echo "Usage: $0 [-v] <local file> <remote file>"
	echo "  -h  display this help message"
	echo "  -v  validators only"
}

NODES=$(grep 'Host ' "$HOME/.ssh/devnet/config" | awk '{print $2}' | xargs)

for arg in "$@"; do
	case $arg in
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

if [ $# -ne 2 ]; then
	usage
	exit 1
fi

LOCAL_FILE=$1
REMOTE_FILE=$2

for n in $NODES; do
	echo "copy to $n"
	scp -F ~/.ssh/devnet/config -i ~/.ssh/devnet/devnet-key -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$LOCAL_FILE" "$n:$REMOTE_FILE"
done
