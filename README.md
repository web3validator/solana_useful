# solana_useful
Useful to run solana validator

Check this link https://teletype.in/@in_extremo/solana_useful
```bash
sh -c "$(curl -sSfL https://release.solana.com/v1.9.4/install)"
```
# add solana into PATH
```bash
sudo su

echo "export PATH="/root/.local/share/solana/install/active_release/bin:$PATH"" >> ~/.bashrc

source ~/.bashrc
```


# Easy UPDATE

```bash
sudo su
solana-install init 1.8.14
solana-validator --ledger ~/solana/ledger wait-for-restart-window && systemctl restart solana 
echo done
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
# Testnet service

```bash
sudo su
rm /etc/systemd/system/solana.service
nano /etc/systemd/system/solana.service
```
```bash
[Unit]
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
--dynamic-port-range 8000-8020 \
--log /root/solana/solana.log \
--snapshot-interval-slots 1000 \
--maximum-local-snapshot-age 2000 \
--no-port-check \
--private-rpc \
--rpc-port 8899
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
tmpfs /mnt/ramdisk tmpfs nodev,nosuid,noexec,nodiratime,size=128G 0 0
``` 
```bash
mkdir -p /mnt/ramdisk
mount /mnt/ramdisk
``` 
#add to solana.service
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

