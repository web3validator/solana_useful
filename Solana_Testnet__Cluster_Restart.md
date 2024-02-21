

### Instruction is written for an appendics

 Install new version
```
solana-install init v1.18.2
```
stop service, delete ledger
```bash
systemctl stop solana
rm -rf /mnt/data/solana/ledger/snapshot-*
rm -rf /mnt/data/solana/ledger/incremental-*
```
download appropriate snapshot
```bash
wget --trust-server-names -P $HOME/ttt http://testnet.solana.margus.one/snapshot.tar.bz2 -P /mnt/data/solana/ledger/
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
--limit-ledger-size 50000000 \
--dynamic-port-range 9050-9070 \
--log /root/solana/solana.log \
--full-snapshot-interval-slots 25000 \
--incremental-snapshot-interval-slots 500 \
--no-port-check \
--rpc-port 8899 \
--full-rpc-api \
--private-rpc \
--wait-for-supermajority 254108257 \
--expected-shred-version 35459 \
--expected-bank-hash 4rWEDhTyQVgTw6sPoCthXmUNmjeiwsdKQ5ZNvpEi3uvk \
--no-snapshot-fetch
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
[Install]
WantedBy=multi-user.target
```
#restart solana service

```bash
systemctl daemon-reload
systemctl restart solana
```
## check the log and WAIT 2-3 min
```bash
tail -f ~/solana/solana.log | grep 'Waiting for'
```

If you see this logs output after a while
```bash
[2023-11-30T01:56:08.057158618Z INFO  solana_core::validator] Waiting for 80% of activated stake at slot 237692256 to be in gossip...
```
you are good to go =)
