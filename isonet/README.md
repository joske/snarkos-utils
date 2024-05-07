# ISONET testing

## Build snarkos on ubuntu 22.04 LTS

Use this Dockerfile that installs rust and a host of nice tools and checks out snarkOS/snarkVM:
https://github.com/joske/rust-ubuntu/tree/snarkos

**make sure to checkout the snarkos branch - the master branch builds on a later non-LTS ubuntu**

Build the container

```bash
docker build -t ubuntu-rust:snarkos .
```

Run the container and login (we start the container in the background with `-d` so it can stay running)

```bash
docker run -d -ti --name snarkos --init ubuntu-rust bash
docker exec -ti snarkos bash
```

Inside this container, make your modifications in /home/rust/build/snarkOS and build:

```bash
cargo build --release --features metrics
```

Use the `copy_docker.sh` script to copy the snarkos binary from the container to the remote host (giving it a suffix per test)

```bash
./copy_docker.sh <test-feature>
```

## Devnet keys

Install the isonet keys and config into `$HOME/.ssh/devnet/`

You can then log in to the remote machines using

```bash
ssh -F ~/.ssh/devnet/config -i ~/.ssh/devnet/devnet-key <remote>
```

You can copy local files to the remote:

```bash
scp -F ~/.ssh/devnet/config -i ~/.ssh/devnet/devnet-key <local file> <remote>:
```

## Instrument the remote host

On the remote, install heaptrack

```bash
sudo apt install heaptrack
```

Copy the `snarkos-heaptrack.service` file to the remote and place it in `/etc/systemd/system`

Reload systemd config:

```bash
sudo systemctl daemon-reload
```

Copy the `heaptrack.sh` script to the remote

## Run a test

Copy the modified `snarkos` binary to the remote

```bash
scp -F ~/.ssh/devnet/config -i ~/.ssh/devnet/devnet-key snarkos-test-feature <remote>:
```

Symlink this binary to a name the `heaptrack.sh` script expects (the image name must be `snarkos` for the grafana process exporter to see the process)

```bash
ln -sf snarkos-test-feature snarkos
```

Run the test, it will stop the default `snarkos.service` and start `snarkos-heaptrack.service` for 30 minutes, then restart the original `snarkos` binary

```bash
./heaptrack.sh
```

The heaptrack file will appear in `/home/ubuntu/heaptrack.snarkos.<pid>.zst`.

## Restarting all nodes

Sometimes the nodes get stuck. You can restart them all using the `restart-all-nodes.sh` script.
