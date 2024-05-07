#!/bin/bash

if [ -z "$1" ]; then
	echo "Usage: $0 <suffix> [remote]"
	echo "  suffix: suffix to append to the binary name"
	echo "  remote: remote host to copy the binary to (default: snarkos-client-node-group-6-0)"
	exit 1
fi

SUFFIX=$1
REMOTE=${2:-snarkos-client-node-group-6-0}

docker cp snarkos:/home/rust/build/snarkOS/target/release/snarkos snarkos-$SUFFIX
scp -F ~/.ssh/devnet/config -i ~/.ssh/devnet/devnet-key snarkos-$SUFFIX $REMOTE:
