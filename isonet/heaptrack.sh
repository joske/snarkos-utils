#!/bin/bash

function die {
	echo -e "\e[0;31mAargh, please fix me manually\e[0m"
	exit 1
}

echo "$(date '+%T') stopping base snarkOS"
sudo systemctl stop snarkos || die
echo "$(date '+%T') starting instrumented snarkOS"
sudo systemctl start snarkos-heaptrack || die
echo "$(date '+%T') started instrumented snarkOS"
sleep 30m
echo "$(date '+%T') stopping instrumented snarkOS"
sudo systemctl stop snarkos-heaptrack || die
echo "$(date '+%T') starting base snarkOS"
sudo systemctl start snarkos || die
