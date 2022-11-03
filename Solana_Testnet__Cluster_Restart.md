#Stop and rm ledger, and backup service

```bash
systemctl stop solana
solana-install init v1.14.7
rm -rf /root/solana/ledger/
mkdir /root/solana/ledger/
wget --trust-server-names http://194.126.172.246:8899/snapshot.tar.bz2 -P /root/solana/validator-ledger
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
LimitNOFILE=1000000
Environment="SOLANA_METRICS_CONFIG=host=https://metrics.solana.com:8086,db=tds,u=testnet_write,p=c4fa841aa918bf8274e3e2a44d77568d9861b3ea"
ExecStart=/root/.local/share/solana/install/active_release/bin/solana-validator \
--wait-for-supermajority 160991176 \
--expected-shred-version 8135 \
--entrypoint entrypoint.testnet.solana.sergo.dev:8001 \
--entrypoint entrypoint.testnet.solana.com:8001 \
--entrypoint entrypoint2.testnet.solana.com:8001 \
--entrypoint entrypoint3.testnet.solana.com:8001 \
--expected-bank-hash 8EuZtx8JvEjtjByCYxxdpSsDu23WhYqN5LVrSRUurKLA \
--known-validator eoKpUABi59aT4rR9HGS3LcMecfut9x7zJyodWWP43YQ \
--known-validator 141vSYKGRPNGieSrGJy8EeDVBcbjSr6aWkimNgrNZ6xN \
--known-validator FnpP7TK6F2hZFVnqSUJagZefwRJ4fmnb1StS1NokpLZM \
--known-validator BFquPCAYdjN9QyLVfuGrQdJTF9Ct7Z85FDxhFeLcpFqR \
--known-validator AJLWyfaLmio6Gm8GA76mdfUtuLT4tmyZsLhbpXsndNab \
--no-snapshot-fetch \
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
#Start and check log

```bash
systemctl daemon-reload
systemctl restart solana
tail -f ~/solana/solana.log | grep 'Waiting for'
```
