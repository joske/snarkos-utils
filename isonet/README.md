# ISONET testing

## Build snarkos on ubuntu 22.04 LTS

Use this Dockerfile that installs rust and a host of nice tools and checks out snarkOS/snarkVM:
https://github.com/joske/rust-ubuntu/tree/snarkos

**make sure to checkout the snarkos branch - the master branch builds on latest LTS (24.04, noble)**

Build the container

```bash
docker build -t rust-ubuntu:snarkos .
```

Run the container and login (we start the container in the background with `-d` so it can stay running)

```bash
docker run -d -ti --name snarkos --init rust-ubuntu:snarkos bash
docker exec -ti snarkos bash
```

Inside this container, make your modifications in /home/rust/build/snarkOS and build:

```bash
export JEMALLOC_SYS_WITH_MALLOC_CONF="dirty_decay_ms:0,muzzy_decay_ms:0,confirm_conf:true"
cargo build --release --features metrics
```

Use the `copy_docker.sh` script (outside of the container) to copy the snarkos binary from the container to the remote host (giving it a suffix per test)

```bash
./copy_docker.sh <test-feature> [remote]
```

(You can also pass in in a remote node as extra argument)

## Devnet keys

Install the isonet keys and config into `$HOME/.ssh/devnet/`

If we get only the output 'json' files, you can use the following oneliner to generate an ssh config:

```bash
cat <output.json> | grep -v snarkos_lb | grep -E 'name|public_ip' | paste -d" " - - | sed 's/.*"name" = "\([^"]*\)".*public_ip" = "\(.*\)"/Host \1\n\tHostName \2\n\tUser ubuntu/' > ~/.ssh/devnet/config
```

The following aliases are useful:

```bash
alias devnet-ssh='ssh -F ~/.ssh/devnet/config -i ~/.ssh/devnet/devnet-key -o StrictHostKeyChecking=no -o ConnectTimeout=5'
alias devnet-scp='scp -F ~/.ssh/devnet/config -i ~/.ssh/devnet/devnet-key -o StrictHostKeyChecking=no -o ConnectTimeout=5'
```

You can then log in to the remote machines using

```bash
devnet-ssh <remote>
```

You can copy local files to the remote:

```bash
devnet-scp <local file> <remote>:
```

## Instrument the remote host

On the remote, install heaptrack

```bash
sudo apt install heaptrack
```

Copy the `snarkos-heaptrack.service` file to the remote and place it in `/etc/systemd/system`

**don't forget to change the dev number - also, check if your remote is a client as this file is only for clients, adapt as necessary**

Reload systemd config:

```bash
sudo systemctl daemon-reload
```

Copy the `heaptrack.sh` script to the remote

## Run a test

Copy the modified `snarkos` binary to the remote

```bash
copy_docker.sh snarkos-test-feature <remote>
```

The above command will pull the `/home/rust/build/snarkOS/target/release/snarkos` binary locally, rename it to `snarkos-test-feature` and copy it to `<remote>`.

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
