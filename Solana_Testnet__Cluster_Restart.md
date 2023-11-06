

```
solana-install init v1.14.23
```
```bash
wget --content-disposition http://139.178.68.207:8899/snapshot.tar.bz2 -P /root/solana/ledger
```

```bash
rm /etc/systemd/system/solana.service
nano /etc/systemd/system/solana.service
```
```
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
--entrypoint testnet.solana.margus.one:8001 \
--entrypoint entrypoint.testnet.solana.com:8001 \
--entrypoint entrypoint2.testnet.solana.com:8001 \
--entrypoint entrypoint3.testnet.solana.com:8001 \
--known-validator 5D1fNXzvv5NjV1ysLjirC4WY92RNsVH18vjmcszZd8on \
--known-validator 9e2RvEzemWs6ZkEhdW2NddSWiFKgJfkw5LWGtgwvPnvw \
--known-validator 5eiHbh7oTMByatSxoxtgpNfu9hQj8kf1Ltyr83bFsSd9 \
--known-validator ENCVKduwGMUc3ZfVGZLyuUrwwQiR2YLbsP6y2bitnCV6 \
--wait-for-supermajority 213932256 \
--expected-shred-version 61807 \
--expected-bank-hash 4cyHLxMPCJH4pq9v6eVDFBKKNwrVw8ww78yYUSJNDvjU \
--no-snapshot-fetch \
--only-known-rpc \
--expected-genesis-hash 4uhcVJyU9pJkvQyS88uRDiswHXSCkY3zQawwpjk2NsNY \
--wal-recovery-mode skip_any_corrupted_record \
--identity /root/solana/validator-keypair.json \
--vote-account /root/solana/vote-account-keypair.json \
--ledger /root/solana/ledger \
--limit-ledger-size 50000000 \
--dynamic-port-range 9050-9070 \
--log /root/solana/solana.log \
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
#Start and check log

```bash
systemctl daemon-reload
systemctl restart solana
tail -f ~/solana/solana.log | grep 'Waiting for'
```
