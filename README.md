# solana_useful
Useful to run solana validator

[Jito Upgrading](https://github.com/web3validator/solana_useful/blob/main/README.md#jito-upgrading)

[Mainnet service](https://github.com/web3validator/solana_useful/blob/main/README.md#mainnet-service)

Check this link https://teletype.in/@in_extremo/solana_useful
```bash
sh -c "$(curl -sSfL https://release.solana.com/v1.18.8/install)"
```
# add solana into PATH
```bash
echo "export PATH="/root/.local/share/solana/install/active_release/bin:$PATH"" >> ~/.bashrc

source ~/.bashrc
```

# check when your block

```bash
tail -f $HOME/solana/solana.log | awk -v pattern="`solana address`.+within slot" '$0 ~ pattern {printf "%d hr. %d min. %d sec.\n", ($18-$12)*0.459/3600, ($18-$12)*0.459/60-int((($18-$12)*0.459/3600))*60, ($18-$12)*0.459-int((($18-$12)*0.459/3600))*3600-int((($18-$12)*0.459/60))*60}'

```
# Download snapshot from trust-server
```bash
cd ~/solana/ledger
wget --backups=1 --trust-server-names http://testnet.solana.com/snapshot.tar.bz2
wget --backups=1 --trust-server-names http://testnet.solana.com/incremental-snapshot.tar.bz2
systemctl restart solana
```
# Easy UPDATE
firstly check when your block >>
```bash
solana-install init 1.17.22
solana-validator --ledger /root/solana/ledger wait-for-restart-window && systemctl restart solana
```
fast catchup after restart
```bash
solana-validator --ledger /root/solana/ledger wait-for-restart-window && systemctl restart solana
```
or
```bash
solana-validator --ledger /mnt/data/solana/ledger exit && systemctl daemon-reload && systemctl restart solana
```
# Jito Things 

### INSTALATTION 

(you don't need this one if you wanna just upgrade)

install rust
```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
install some dependencies
```bash
sudo apt-get -y install libssl-dev libudev-dev pkg-config zlib1g-dev llvm clang make
```
install protobuf-compiler 
```bash
sudo apt install protobuf-compiler
```
download if you need
```bash
git clone https://github.com/jito-foundation/jito-solana.git
```
# Jito Upgrading 
```bash
export TAG=v1.17.28-jito # tag
```
```bash
cd ~/jito-solana
git pull
git checkout tags/$TAG
git submodule update --init --recursive
CI_COMMIT=$(git rev-parse HEAD) scripts/cargo-install-all.sh ~/.local/share/solana/install/releases/"$TAG"
```
delete old active_release and substite to the new_one

```bash
cd ~/.local/share/solana/install/releases && rm -rf active_release && mv $TAG active_release
```
check that version is correct

```bash
/root/.local/share/solana/install/releases/active_release/bin/solana -V
```
fast catchup after restart
```bash
solana-validator --ledger /mnt/data/solana/ledger exit && systemctl daemon-reload && systemctl restart solana
```

check logs
```bash
tail -f ~/solana/solana.log
```

check catchup
```bash
solana catchup --our-localhost
```

# increase nofile
```bash
sudo bash -c "cat >/etc/sysctl.d/21-solana-validator.conf <<EOF
# Increase UDP buffer sizes
net.core.rmem_default = 134217728
net.core.rmem_max = 134217728
net.core.wmem_default = 134217728
net.core.wmem_max = 134217728
# Increase memory mapped files limit
vm.max_map_count = 2048000
# Increase number of allowed open file descriptors
fs.nr_open = 2048000
EOF"
sysctl -p /etc/sysctl.d/21-solana-validator.conf
sudo bash -c "cat >/etc/security/limits.d/90-solana-nofiles.conf <<EOF
# Increase process file descriptor count limit
* - nofile 2048000
EOF"
```

# mitigate the vulnerability
Fortunately, to mitigate the vulnerability is very easy. You do not need to stop any services or restart the computers. You just need to issue two commands on the node and gateway computers.
```bash
sudo /bin/bash -c 'echo "kernel.unprivileged_userns_clone=0" >> /etc/sysctl.conf'

sudo sysctl -p
```
# install TRIM and performance mode
manual trim
```bash
fstrim -va
```
service
```bash
systemctl edit fstrim.timer
```

Paste:

```bash
[Timer]
OnCalendar=daily
```

performance mode:
```bash
for i in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo performance > $i; done
```
===========================================================================

```bash
solana-keygen new -o ~/solana/vote-account-keypair.json
```
or
```bash
solana-keygen recover -o ~/solana/validator-keypair.json
```
```bash
solana-keygen recover -o ~/solana/vote-account-keypair.json
```
```bash
solana create-vote-account ~/solana/vote-account-keypair.json ~/solana/validator-keypair.json ~/solana/withdrawer.json 
```
=============================================
# you can switch log record to warn only
```bash
Environment="RUST_LOG=warn"
```
### write config

```bash
solana config set --url https://api.testnet.solana.com --keypair ~/solana/validator-keypair.json
```
```bash
solana config set --url https://api.mainnet-beta.solana.com --keypair ~/solana/validator-keypair.json
```
=================================
# Testnet service

```bash
sudo su
rm /etc/systemd/system/solana.service
nano /etc/systemd/system/solana.service
```
```bash
[Unit]
Description=Solana testnet node
After=network.target syslog.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
LimitNOFILE=2048000
Environment="SOLANA_METRICS_CONFIG=host=https://metrics.solana.com:8086,db=tds,u=testnet_write,p=c4fa841aa918bf8274e3e2a44d77568d9861b3ea"
ExecStart=/root/.local/share/solana/install/active_release/bin/solana-validator \
--entrypoint entrypoint.testnet.solana.com:8001 \
--entrypoint entrypoint2.testnet.solana.com:8001 \
--entrypoint entrypoint3.testnet.solana.com:8001 \
--known-validator 5D1fNXzvv5NjV1ysLjirC4WY92RNsVH18vjmcszZd8on \
--known-validator 7XSY3MrYnK8vq693Rju17bbPkCN3Z7KvvfvJx4kdrsSY \
--known-validator Ft5fbkqNa76vnsjYNwjDZUXoTWpP7VYm3mtsaQckQADN \
--known-validator 9QxCLckBiJc783jnMvXZubK4wH86Eqqvashtrwvcsgkv \
--expected-genesis-hash 4uhcVJyU9pJkvQyS88uRDiswHXSCkY3zQawwpjk2NsNY \
--only-known-rpc \
--wal-recovery-mode skip_any_corrupted_record \
--identity /root/solana/validator-keypair.json \
--vote-account /root/solana/vote-account-keypair.json \
--ledger /mnt/data/solana/ledger \
--accounts /mnt/data2/solana/accounts \
--snapshots /mnt/data2/solana/snapshots \
--limit-ledger-size 50000000 \
--dynamic-port-range 9050-9070 \
--log /dev/null \
--full-snapshot-interval-slots 25000 \
--incremental-snapshot-interval-slots 500 \
--no-port-check \
--rpc-port 8899 \
--full-rpc-api \
--private-rpc
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
[Install]
WantedBy=multi-user.target
```

```bash
systemctl daemon-reload

systemctl enable solana

systemctl restart solana
```
```bash
tail -f ~/solana/solana.log
```

# MAINNET service

```bash
sudo su
rm /etc/systemd/system/solana.service
nano /etc/systemd/system/solana.service
```



```bash
[Unit]
Description=Solana Validator
After=network.target
StartLimitIntervalSec=0

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
LimitNOFILE=2048000
Environment="SOLANA_METRICS_CONFIG=host=https://metrics.solana.com:8086,db=mainnet-beta,u=mainnet-beta_write,p=password"
ExecStart=/root/.local/share/solana/install/active_release/bin/solana-validator \
--dynamic-port-range 8000-8020 \
--entrypoint entrypoint.mainnet-beta.solana.com:8001 \
--entrypoint entrypoint2.mainnet-beta.solana.com:8001 \
--entrypoint entrypoint3.mainnet-beta.solana.com:8001 \
--entrypoint entrypoint4.mainnet-beta.solana.com:8001 \
--entrypoint entrypoint5.mainnet-beta.solana.com:8001 \
--identity /root/solana/validator-keypair.json \
--vote-account /root/solana/vote-account-keypair.json \
--known-validator 7Np41oeYqPefeNQEHSv1UDhYrehxin3NStELsSKCT4K2 \
--known-validator GdnSyH3YtwcxFvQrVVJMm1JhTS4QVX7MFsX56uJLUfiZ \
--known-validator DE1bawNcRJB9rVm3buyMVfr8mBEoyyu73NBovf2oXJsJ \
--known-validator CakcnaRDHka2gXyfbEd2d3xsvkJkqsLw2akB3zsN1D2S \
--expected-genesis-hash 5eykt4UsFv8P8NJdTREpY1vzqKqZKvdpKuc147dw2N9d \
--gossip-port 8001 \
--rpc-port 8899 \
--log /dev/null \
--private-rpc \
--rpc-bind-address 127.0.0.1 \
--ledger /root/solana/ledger \
--limit-ledger-size 50000000 \
--wal-recovery-mode skip_any_corrupted_record \
--maximum-local-snapshot-age 5000 \
--snapshot-interval-slots 500 \
--no-port-check \
--no-poh-speed-test \
--skip-poh-verify
[Install]
WantedBy=multi-user.target
```
=============================


Add this flag if your disk is so slow

`--no-skip-initial-accounts-db-clean \`

```bash
systemctl daemon-reload

systemctl enable solana

systemctl restart solana
```

=============================


```bash
nano /etc/logrotate.d/solana.logrotate
```
===========
```bash
/root/solana/solana.log {
  rotate 7
  daily
  missingok
  postrotate
    systemctl kill -s USR1 solana.service
  endscript
}
```


```bash
 solana-validator --ledger /root/ledger wait-for-restart-window && systemctl restart solana
```

```bash
tail -f /root/solana/solana.log
```

```bash
solana catchup ~/solana/validator-keypair.json --our-localhost
```
==========

```bash
solana validator-info publish "web34ever" -w "https://web3validator.info" -i "https://prnt.sc/5ihpwIyeMhjy" -d "Crypto is going mainstream. We help you go upstream" -k validator-keypair.json
```
=
change vote author withdrawer
=
```bash
solana vote-authorize-withdrawer "/root/solana/vote-account-keypair.json" "/root/solana/validator-keypair.json" "/root/solana/solflare-raw-key-7EWKPuLVsbMQGpPtBa5HWNyb9djfndimok5iqrpF39n.json"
```
====================
```bash
solana vote-update-commission ~/solana/vote-account-keypair.json 10 w.json
```
=============


=======
ramdisk
-====

###########################
          swap
###########################

# swap
```bash
swapon --show
```
=(

```bash
touch /mnt/data2/swap.img
```

```bash
chmod 0600 /mnt/data2/swap.img
```
```bash
fallocate -l 256G /mnt/data2/swap.img && mkswap /mnt/data2/swap.img && swapon /mnt/data2/swap.img
```
```bash
swapon --show
```
=)

```bash
echo '/mnt/data2/swap.img none swap sw 0 0' >> /etc/fstab
```
# Ramdisk

create swapfile
```bash
swapoff -a
dd if=/dev/zero of=/swapfile bs=1G count=128
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
```
```bash
nano /etc/fstab
```
```bash
/swapfile none swap sw 0 0
tmpfs /mnt/ramdisk tmpfs nodev,nosuid,noexec,nodiratime,size=128G 0 0
``` 
```bash
mkdir -p /mnt/ramdisk
mount /mnt/ramdisk
``` 
#add to solana.service
```bash
nano /etc/systemd/system/solana.service
``` 
```bash
--accounts /mnt/ramdisk/accounts
``` 
# ufw
###########################
          Ufw
###########################
```bash
ufw allow 22
ufw allow 8000/tcp
ufw allow 8000:8020/tcp
ufw allow 8000:8020/udp

ufw enable
```
denylocal traffic
```bash
ufw deny out from any to 10.0.0.0/8
ufw deny out from any to 172.16.0.0/12
ufw deny out from any to 192.168.0.0/16
ufw deny out from any to 100.64.0.0/10
ufw deny out from any to 198.18.0.0/15
ufw deny out from any to 169.254.0.0/16
```
testnet
```bash
ufw allow 22
ufw allow 8000/tcp
ufw allow 9050:9070/tcp
ufw allow 9050:9070/udp
```

```bash
ufw status
```

