#Stop and rm ledger, and backup service

```bash
sudo su
cd ~/solana/
systemctl stop solana
cat solana.log  | grep 'optimistic_slot slot=' | tail -n1000 | cut -d "=" -f2 | tr -d i | sort -n | tail -n1
```
  
  
```bash
sudo su
rm /etc/systemd/system/solana.service 
nano /etc/systemd/system/solana.service
```


#Copy and paste the following service text


```bash
[Unit]
Description=Solana Node
After=network.target syslog.target
StartLimitIntervalSec=0
[Service]
Type=simple
Restart=always
RestartSec=1
LimitNOFILE=1024000
Environment="SOLANA_METRICS_CONFIG=host=https://metrics.solana.com:8086,db=tds,u=testnet_write,p=c4fa841aa918bf8274e3e2a44d77568d9861b3ea"
ExecStart=/root/.local/share/solana/install/active_release/bin/solana-validator \
--entrypoint 5.9.35.85:8001 \
--entrypoint entrypoint.testnet.solana.com:8001 \
--entrypoint entrypoint2.testnet.solana.com:8001 \
--entrypoint entrypoint3.testnet.solana.com:8001 \
--known-validator eoKpUABi59aT4rR9HGS3LcMecfut9x7zJyodWWP43YQ \
--known-validator 4ZtE2XX6oQThPpdjwKXVMphTTZctbWwYxmcCV6xR11RT \
--known-validator 8SRKNfvMerfA1BdU79CAwU4wNfjnDvFrBo3o5f5TS4uv \
--known-validator 9v7E6oEm1V86hjTubtBon7cRYPvQriWZKHZEX6j92Po4 \
--known-validator 3viEMMqkPRBiAKXB3Y7yH5GbzqtRn3NmnLPi8JsZmLQw \
--known-validator 3iPu9xQ3mCFmqME9ZajuZbFHjwagAxhgfTxnc4pWbEBC \
--only-known-rpc \
--expected-shred-version 24371 \
--expected-genesis-hash 4uhcVJyU9pJkvQyS88uRDiswHXSCkY3zQawwpjk2NsNY \
--wait-for-supermajority 144871251 \
--no-genesis-fetch \
--no-snapshot-fetch \
--expected-bank-hash 4NstanApNPjCAd2HwBhHokqCQbJfCAYgp92VvJibSM5M \
--wal-recovery-mode skip_any_corrupted_record \
--identity /root/solana/validator-keypair.json \
--vote-account /root/solana/vote-account-keypair.json \
--ledger /root/solana/ledger \
--snapshot-compression none \
--incremental-snapshots \
--full-snapshot-interval-slots 30000 \
--incremental-snapshot-interval-slots 500 \
--maximum-full-snapshots-to-retain 1 \
--maximum-incremental-snapshots-to-retain 2 \
--maximum-local-snapshot-age 1500 \
--limit-ledger-size 50000000 \
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
#Start and check log

```bash
systemctl daemon-reload
systemctl restart solana
tail -f ~/solana/solana.log | grep 'Waiting for'
```

# If you start from Appendix

```bash
sudo su
rm -rf ~/solana/ledger
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
LimitNOFILE=1024000
Environment="SOLANA_METRICS_CONFIG=host=https://metrics.solana.com:8086,db=tds,u=testnet_write,p=c4fa841aa918bf8274e3e2a44d77568d9861b3ea"
ExecStart=/root/.local/share/solana/install/active_release/bin/solana-validator \
--entrypoint 5.9.35.85:8001 \
--entrypoint entrypoint.testnet.solana.com:8001 \
--entrypoint entrypoint2.testnet.solana.com:8001 \
--entrypoint entrypoint3.testnet.solana.com:8001 \
--known-validator eoKpUABi59aT4rR9HGS3LcMecfut9x7zJyodWWP43YQ \
--known-validator 4ZtE2XX6oQThPpdjwKXVMphTTZctbWwYxmcCV6xR11RT \
--known-validator 8SRKNfvMerfA1BdU79CAwU4wNfjnDvFrBo3o5f5TS4uv \
--known-validator 9v7E6oEm1V86hjTubtBon7cRYPvQriWZKHZEX6j92Po4 \
--known-validator 3viEMMqkPRBiAKXB3Y7yH5GbzqtRn3NmnLPi8JsZmLQw \
--known-validator 3iPu9xQ3mCFmqME9ZajuZbFHjwagAxhgfTxnc4pWbEBC \
--expected-bank-hash 4NstanApNPjCAd2HwBhHokqCQbJfCAYgp92VvJibSM5M \
--only-known-rpc \
--expected-genesis-hash 4uhcVJyU9pJkvQyS88uRDiswHXSCkY3zQawwpjk2NsNY \
--wait-for-supermajority 144871251 \
--expected-shred-version 24371 \
--wal-recovery-mode skip_any_corrupted_record \
--identity /root/solana/validator-keypair.json \
--vote-account /root/solana/vote-account-keypair.json \
--ledger /root/solana/ledger \
--snapshot-compression none \
--incremental-snapshots \
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
