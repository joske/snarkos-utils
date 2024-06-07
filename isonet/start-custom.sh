#!/bin/bash

if [ "$#" -ne 1 ]; then
	echo "Usage: $0 <version>"
	exit 1
fi

VER=$1

if [ ! -f "$HOME/snarkos-$VER" ]; then
	echo "File not found: $HOME/snarkos-$VER"
	exit 1
fi

ln -sf "$HOME/snarkos-$VER" "$HOME/snarkos"
cd /etc/systemd/system/ || exit 1
sudo cp snarkos.service snarkos-custom.service
sudo sed -i 's!/root/.cargo/bin/snarkos!/home/ubuntu/snarkos!' snarkos-custom.service
sudo sed -i 's!verbosity 1!verbosity 5!' snarkos-custom.service
sudo systemctl daemon-reload
sudo systemctl stop snarkos.service
sudo systemctl restart snarkos-custom.service
cd || exit 1
