#Stop and rm ledger, and backup service

```bash
systemctl stop solana
rm -rf ~/solana/ledger
mv /etc/systemd/system/solana.service /etc/systemd/system/solana.service.bak
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
--entrypoint entrypoint.testnet.solana.com:8001 \
--entrypoint entrypoint2.testnet.solana.com:8001 \
--entrypoint entrypoint3.testnet.solana.com:8001 \
--expected-bank-hash E3MJucWkWkugqJ8ewHAkDWuCN6uDxEychwjFFCwJ16ic \
--known-validator 3K8BYGTPD9AxqYQDPdU8PPy6AfiSwf4hDmFy1xXGB8Ns \
--known-validator 5dB4Ygb8Sf3Sssdxxrpbb4NFX9bMrYnieiz11Vr5xJkJ \
--known-validator 7TcmJn12spW6KQJp4fvvo45d1hpxS8EnLjKMxihtNZ1V \
--known-validator 4jhyvbBHbsRDF6och7pDQ7ahYTUr7wNkAYJTLLuMUtku \
--known-validator 4rVaXrd7BLSFZMSm4Lq63nxkVyezGxsQVpUhc9LqbxVk \
--known-validator 82k4RGZAJxtXvW3hzgmHB2q4oDHzgwMR2cGXup324gsJ \
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
--rpc-bind-address 127.0.0.1 \
--rpc-port 8899 \
--wait-for-supermajority 95038710 \
--expected-shred-version 50850
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

