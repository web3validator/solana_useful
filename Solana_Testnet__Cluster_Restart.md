#Stop and rm ledger, and backup service

```bash
systemctl stop solana
solana-install init v1.8.11
rm -rf ~/solana/ledger
rm /etc/systemd/system/solana.service 
nano /etc/systemd/system/solana.service
```

#Copy and paste the following service text


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
--rpc-bind-address 127.0.0.1 \
--rpc-port 8899 \
--no-snapshot-fetch \
--no-genesis-fetch \
--expected-shred-version 12339 \
--wait-for-supermajority 110973418 \
--expected-shred-version 12339 \
--entrypoint 5.9.35.85:8001 \
--entrypoint entrypoint.testnet.solana.com:8001 \
--entrypoint entrypoint2.testnet.solana.com:8001 \
--entrypoint entrypoint3.testnet.solana.com:8001 \
--expected-bank-hash WVDsuJJbhcdqH6vQrpZi5GYoPnMAaKw4THMtwes77DS \
--known-validator eoKpUABi59aT4rR9HGS3LcMecfut9x7zJyodWWP43YQ \
--known-validator 4z755TDizaUVyRRKw7y8DnTnnon8ksQYsZyU3feF6yFc \
--known-validator Bszp6hDL19ymPZ8efp9venQYb4ae2rRmEtVp4aG6k8nx \
--known-validator 8SRKNfvMerfA1BdU79CAwU4wNfjnDvFrBo3o5f5TS4uv \
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

