# solana_useful
Useful to run solana validator

Check this link https://teletype.in/@in_extremo/solana_useful
```bash
sh -c "$(curl -sSfL https://release.solana.com/v1.14.7/install)"
```
# add solana into PATH
```bash
sudo su

echo "export PATH="/root/.local/share/solana/install/active_release/bin:$PATH"" >> ~/.bashrc

source ~/.bashrc
```

# check when your block

```bash
sudo su
solana -V
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
sudo su
solana-install init 1.14.6
systemctl restart solana 
solana catchup ~/solana/validator-keypair.json --our-localhost
```
Check catchup

```bash
solana catchup --our-localhost
```

```bash
sudo bash -c "cat >/etc/sysctl.d/21-solana-validator.conf <<EOF
# Increase UDP buffer sizes
net.core.rmem_default = 134217728
net.core.rmem_max = 134217728
net.core.wmem_default = 134217728
net.core.wmem_max = 134217728

# Increase memory mapped files limit
vm.max_map_count = 1000000

# Increase number of allowed open file descriptors
fs.nr_open = 1000000
EOF"

sudo sysctl -p /etc/sysctl.d/20-solana-udp-buffers.conf

sudo bash -c "cat >/etc/security/limits.d/90-solana-nofiles.conf <<EOF
# Increase process file descriptor count limit
* - nofile 1000000
EOF"

sudo sysctl -p /etc/sysctl.d/20-solana-mmaps.conf

sudo bash -c "cat >/etc/security/limits.d/90-solana-nofiles.conf <<EOF
# Increase process file descriptor count limit
* - nofile 700000
EOF"
```
# mitigate the vulnerability
Fortunately, to mitigate the vulnerability is very easy. You do not need to stop any services or restart the computers. You just need to issue two commands on the node and gateway computers.
```bash
sudo /bin/bash -c 'echo "kernel.unprivileged_userns_clone=0" >> /etc/sysctl.conf'

sudo sysctl -p
```
# install TRIM and performance mode

```bash
systemctl edit fstrim.timer
```

Paste:

```bash
[Timer]
OnCalendar=daily
```
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

# install sys-tuner service
```bash
nano /etc/systemd/system/sstd.service
```
```bash
[Unit]
Description=Solana System Tuning
After=network.target
Before=solana.service

[Service]
User=root
ExecStart=/root/.local/share/solana/install/active_release/bin/solana-sys-tuner --user root
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
```
```bash
systemctl daemon-reload
systemctl start sstd
systemctl enable sstd
```
==================================

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
Description=Solana Node
After=network.target syslog.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
LimitNOFILE=1000000
Environment="SOLANA_METRICS_CONFIG=host=https://metrics.solana.com:8086,db=tds,u=testnet_write,p=c4fa841aa918bf8274e3e2a44d77568d9861b3ea"
ExecStart=/root/.local/share/solana/install/active_release/bin/solana-validator \
--entrypoint entrypoint.testnet.solana.com:8001 \
--entrypoint entrypoint2.testnet.solana.com:8001 \
--entrypoint entrypoint3.testnet.solana.com:8001 \
--known-validator 5D1fNXzvv5NjV1ysLjirC4WY92RNsVH18vjmcszZd8on \
--known-validator dDzy5SR3AXdYWVqbDEkVFdvSPCtS9ihF5kJkHCtXoFs \
--known-validator Ft5fbkqNa76vnsjYNwjDZUXoTWpP7VYm3mtsaQckQADN \
--known-validator eoKpUABi59aT4rR9HGS3LcMecfut9x7zJyodWWP43YQ \
--known-validator 9QxCLckBiJc783jnMvXZubK4wH86Eqqvashtrwvcsgkv \
--only-known-rpc \
--expected-genesis-hash 4uhcVJyU9pJkvQyS88uRDiswHXSCkY3zQawwpjk2NsNY \
--wal-recovery-mode skip_any_corrupted_record \
--identity /root/solana/validator-keypair.json \
--vote-account /root/solana/vote-account-keypair.json \
--ledger /root/solana/ledger \
--snapshot-compression none \
--full-snapshot-interval-slots 30000 \
--incremental-snapshot-interval-slots 500 \
--maximum-full-snapshots-to-retain 1 \
--maximum-incremental-snapshots-to-retain 2 \
--maximum-local-snapshot-age 1500 \
--limit-ledger-size 50000000 \
--no-os-network-limits-test \
--dynamic-port-range 8000-8020 \
--log /root/solana/solana.log \
--private-rpc \
--rpc-bind-address 127.0.0.1 \
--rpc-port 8899
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
LimitNOFILE=1000000
Environment="SOLANA_METRICS_CONFIG="host=https://metrics.solana.com:8086,db=mainnet-beta,u=mainnet-beta_write,p=password""
Environment="EXPECTED_GENESIS_HASH=5eykt4UsFv8P8NJdTREpY1vzqKqZKvdpKuc147dw2N9d"
ExecStart=/root/.local/share/solana/install/active_release/bin/solana-validator \
--known-validator CakcnaRDHka2gXyfbEd2d3xsvkJkqsLw2akB3zsN1D2S \
--known-validator DE1bawNcRJB9rVm3buyMVfr8mBEoyyu73NBovf2oXJsJ \
--known-validator GdnSyH3YtwcxFvQrVVJMm1JhTS4QVX7MFsX56uJLUfiZ \
--known-validator 7Np41oeYqPefeNQEHSv1UDhYrehxin3NStELsSKCT4K2 \
--entrypoint entrypoint.mainnet-beta.solana.com:8001 \
--entrypoint entrypoint2.mainnet-beta.solana.com:8001 \
--entrypoint entrypoint3.mainnet-beta.solana.com:8001 \
--entrypoint entrypoint4.mainnet-beta.solana.com:8001 \
--entrypoint entrypoint5.mainnet-beta.solana.com:8001 \
--identity /root/solana/validator-keypair.json \
--vote-account /root/solana/vote-account-keypair.json \
--ledger /root/solana/ledger \
--limit-ledger-size 50000000 \
--accounts-db-caching-enabled \
--dynamic-port-range 8001-8020 \
--gossip-port 8001 \
--no-port-check \
--rpc-port 8899 \
--rpc-bind-address 127.0.0.1 \
--private-rpc \
--only-known-rpc\
--full-snapshot-interval-slots 30000 \
--incremental-snapshot-interval-slots 500 \
--maximum-full-snapshots-to-retain 1 \
--maximum-incremental-snapshots-to-retain 2 \
--maximum-local-snapshot-age 1500 \
--wal-recovery-mode skip_any_corrupted_record \
--snapshot-compression none \
--expected-genesis-hash $EXPECTED_GENESIS_HASH \
--no-os-network-limits-test \
--log /root/solana/solana.log
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID

[Install]
WantedBy=multi-user.target
```
=============================
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
solana validator-info publish "YourName" -n keybaseUsername -w "https://yoursite.com" -d "Blocks must go on"
```
=
change vote author withdrawer
=
```bash
solana vote-authorize-withdrawer "/root/solana/vote-account-keypair.json" "/root/solana/validator-keypair.json" "/root/solana/solflare-raw-key-7EWKPuLVsbMQGpPtBa5HWNyb9djfndimok5iqrpF39n.json"
```
====================
```bash
solana vote-update-commission ~/solana/vote-account-keypair.json 10 ~/solana/validator-keypair.json
```
=============


=======
ramdisk
-====

#create swapfile
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
#####################################
          Ufw
###########################
```bash
ufw allow 22
ufw allow 8000/tcp
ufw allow 8899/tcp
ufw allow 8900/tcp
ufw allow 8000:8020/tcp
ufw allow 8000:8020/udp

ufw deny out from any to 10.0.0.0/8
ufw deny out from any to 172.16.0.0/12
ufw deny out from any to 192.168.0.0/16
ufw deny out from any to 100.64.0.0/10
ufw deny out from any to 198.18.0.0/15
ufw deny out from any to 169.254.0.0/16

ufw enable
```

testnet use also

```bash
ufw deny proto udp from 65.21.235.66 to any && \
ufw deny proto udp from 94.181.44.170 to any && \
ufw deny proto udp from 141.95.145.179 to any && \
ufw deny proto udp from 198.244.202.108 to any && \
ufw deny proto udp from 45.10.26.12 to any && \
ufw deny proto udp from 162.55.135.186 to any && \
ufw deny proto udp from 146.59.54.127 to any && \
ufw deny proto udp from 5.45.72.79 to any && \
ufw deny proto udp from 68.168.220.110 to any && \
ufw deny proto udp from 5.45.73.111 to any && \
ufw deny proto udp from 141.94.248.167 to any && \
ufw deny proto udp from 5.61.53.201 to any
ufw enable
```
```bash
ufw status
```

