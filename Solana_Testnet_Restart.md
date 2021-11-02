#Stop and rm ledger, and backup service

```bash
systemctl stop solana
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
--entrypoint 5.9.35.85:8000 \
--entrypoint 94.198.53.85:8000 \
--entrypoint 178.170.42.36:8000 \
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
--wait-for-supermajority 101345231 \
--expected-shred-version 51836 \
--expected-bank-hash 4G7KhkE5rBN4ne7GNk4JN4mz72sNxKaHnAS3ypy5rcpW \
--known-validator 5Rjq51GbTVY871gHZsLSknG7a2rqkukBxuanAJYDLVMY \
--known-validator 5dB4Ygb8Sf3Sssdxxrpbb4NFX9bMrYnieiz11Vr5xJkJ \
--known-validator Dg5E8ktH4GWfKL1vuVTdqZJEkAEgtV8LqmSXyLJuZ3q1 \
--known-validator GLKsDBjWBaXHkyMihjpU5ZdKyKWtUpJyE4W7PjEFSEHh
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

