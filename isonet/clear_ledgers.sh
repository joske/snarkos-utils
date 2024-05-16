#!/bin/bash
FAILED=()
SUCCEEDED=()

if [ ! -f "$HOME/.ssh/devnet/config" ]; then
	echo "config file not found in $HOME/.ssh/devnet/config"
	exit 1
fi

NODES=$(grep 'Host ' "$HOME/.ssh/devnet/config" | awk '{print $2}' | xargs)
SSH="ssh -F $HOME/.ssh/devnet/config -i $HOME/.ssh/devnet/devnet-key -o StrictHostKeyChecking=no -o ConnectTimeout=5"

# first stop snarkos and move ledgers
for n in $NODES; do
	if [[ "$n" == *client* ]]; then
		d="${n##*client}"
	else
		d="${n##*-}"
	fi
	echo "stopping snarkos on $n $d"
	if ! $SSH "$n" "sudo systemctl stop snarkos"; then
		echo -e "\x1b[0;31mfailed to stop snarkos on $n\x1b[0m"
		FAILED+=("$n")
		continue
	else
		echo "stopped snarkos on $n"
	fi
	echo "clear ledgers on $n"
	$SSH "$n" "\
		sudo mv /.ledger-0-$d.bak /.ledger-0-$d.bak.bak; \
		sudo mv /.ledger-0-$d /.ledger-0-$d.bak; \
		sudo mv /.current-proposal-cache-0-$d.bak /.current-proposal-cache-0-$d.bak.bak; \
		sudo mv /.current-proposal-cache-0-$d /.current-proposal-cache-0-$d.bak"
	# we ignore errors here because the files may not exist
	echo "cleared ledgers on $n"
	echo
	SUCCEEDED+=("$n")
done

# then restart snarkos
for n in "${SUCCEEDED[@]}"; do
	echo "starting snarkos on $n"
	$SSH "$n" "sudo systemctl start snarkos"
	# assuming we can start if we were able to stop
	echo "started snarkos on $n"
	echo
done

echo Failed nodes: "${FAILED[@]}"
echo Succeeded nodes: "${SUCCEEDED[@]}"
