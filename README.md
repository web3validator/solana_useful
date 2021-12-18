# solana_useful
Useful to run solana validator

Check this link https://teletype.in/@in_extremo/solana_useful
```bash
sh -c "$(curl -sSfL https://release.solana.com/v1.8.5/install)"
```
# add solana into PATH
```bash
sudo su

echo "export PATH="/root/.local/share/solana/install/active_release/bin:$PATH"" >> ~/.bashrc

source ~/.bashrc
```

Посмотреть сколько слотов в эпоху назначено ботом

```bash
solana leader-schedule | grep $(solana address) | wc -l
```

# Easy UPDATE

```bash
solana-install init 1.8.1
```

```bash
solana-validator --ledger ~/solana/ledger wait-for-restart-window && systemctl restart solana && tail -f ~/solana/solana.log
```
Check catchup

```bash
solana catchup ~/solana/validator-keypair.json --our-localhost --follow --log
```

```bash
sudo bash -c "cat >/etc/sysctl.d/20-solana-udp-buffers.conf <<EOF
# Increase UDP buffer size
net.core.rmem_default = 134217728
net.core.rmem_max = 134217728
net.core.wmem_default = 134217728
net.core.wmem_max = 134217728
EOF"

sudo sysctl -p /etc/sysctl.d/20-solana-udp-buffers.conf

sudo bash -c "cat >/etc/sysctl.d/20-solana-mmaps.conf <<EOF
# Increase memory mapped files limit
vm.max_map_count = 700000
EOF"

sudo sysctl -p /etc/sysctl.d/20-solana-mmaps.conf

sudo bash -c "cat >/etc/security/limits.d/90-solana-nofiles.conf <<EOF
# Increase process file descriptor count limit
* - nofile 700000
EOF"
```

=========================================================================================================

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

```bash
sudo su
rm /etc/systemd/system/solana.service

echo
"[Unit]
Description=Solana TdS node
After=network.target syslog.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
LimitNOFILE=1024000
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
--ledger /root/solana/ledger \
--limit-ledger-size 50000000 \
--dynamic-port-range 8000-8010 \
--log /root/solana/solana.log \
--snapshot-interval-slots 500 \
--maximum-local-snapshot-age 1000 \
--no-port-check \
--private-rpc \
--rpc-bind-address 127.0.0.1 \
--rpc-port 8899
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
[Install]
WantedBy=multi-user.target " >> /etc/systemd/system/solana.service

systemctl daemon-reload

systemctl enable solana

systemctl restart solana

```

```bash
systemctl daemon-reload

systemctl enable solana

systemctl restart solana
```

============
MAIN
============
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
LimitNOFILE=1024000
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
--dynamic-port-range 8001-8011 \
--gossip-port 8001 \
--no-port-check \
--rpc-port 8899 \
--rpc-bind-address 127.0.0.1 \
--private-rpc \
--only-known-rpc\
--snapshot-interval-slots 500 \
--maximum-local-snapshot-age 500 \
--wal-recovery-mode skip_any_corrupted_record \
--snapshot-compression none \
--expected-genesis-hash $EXPECTED_GENESIS_HASH \
--log /root/solana/solana.log
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID

[Install]
WantedBy=multi-user.target
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



=======================================

```bash
sh -c "$(curl -sSfL https://release.solana.com/v1.7.14/install)"
```


===================
```bash
solana config set --url https://api.testnet.solana.com --keypair ~/solana/validator-keypair.json
```
```bash
solana config set --url https://api.mainnet-beta.solana.com --keypair ~/solana/validator-keypair.json
```
========
```bash
systemctl daemon-reload


systemctl enable solana


systemctl start solana
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
tmpfs /mnt/ramdisk tmpfs nodev,nosuid,noexec,nodiratime,size=200G 0 0
``` 
```bash
mkdir -p /mnt/ramdisk
mount /mnt/ramdisk
``` 
#add to solana.service
```bash
--accounts /mnt/ramdisk/accounts
``` 
#####################################
          Ufw
###########################
```bash
ufw allow 22
ufw allow 8000/tcp
ufw allow 8899/tcp
ufw allow 8900/tcp
ufw allow 8000:8010/tcp
ufw allow 8000:8010/udp

ufw deny out from any to 10.0.0.0/8
ufw deny out from any to 172.16.0.0/12
ufw deny out from any to 192.168.0.0/16
ufw deny out from any to 100.64.0.0/10
ufw deny out from any to 198.18.0.0/15
ufw deny out from any to 169.254.0.0/16

ufw enable
```
```bash
ufw status
```

