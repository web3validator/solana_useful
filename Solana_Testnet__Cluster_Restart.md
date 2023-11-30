
### Instruction is written for an appendics

 Install new version
```
solana-install init v1.16.20
```
stop service, delete ledger
```bash
systemctl stop solana
rm -rf /root/solana/ledger/*
```
download appropriate snapshot
```bash
wget --trust-server-names http://testnet.solana.margus.one/snapshot.tar.bz2 -P /root/solana/ledger/
```
change service parameters
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
--no-snapshot-fetch \
--wait-for-supermajority 237692256 \
--expected-shred-version 5106 \
--expected-bank-hash 5F6SxymLj1v88JcupVgSHwiCBvtsu8ekA82E1ntaCPqh \
--expected-genesis-hash 4uhcVJyU9pJkvQyS88uRDiswHXSCkY3zQawwpjk2NsNY \
--only-known-rpc \
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

If you see this logs output after a while
```bash
[2023-11-30T01:56:08.057158618Z INFO  solana_core::validator] Waiting for 80% of activated stake at slot 237692256 to be in gossip...
```
you are good to go =)
