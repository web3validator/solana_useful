#Stop and rm ledger, and backup service

```bash
sudo su
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
--known-validator 8SRKNfvMerfA1BdU79CAwU4wNfjnDvFrBo3o5f5TS4uv 
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

MAINNET


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
--expected-shred-version 51382 \
--known-validator PUmpKiNnSVAZ3w4KaFX6jKSjXUNHFShGkXbERo54xjb \
--known-validator SerGoB2ZUyi9A1uBFTRpGxxaaMtrFwbwBpRytHefSWZ \
--known-validator FLVgaCPvSGFguumN9ao188izB4K4rxSWzkHneQMtkwQJ \
--known-validator qZMH9GWnnBkx7aM1h98iKSv2Lz5N78nwNSocAxDQrbP \
--known-validator GiYSnFRrXrmkJMC54A1j3K4xT6ZMfx1NSThEe5X2WpDe \
--known-validator LA1NEzryoih6CQW3gwQqJQffK2mKgnXcjSQZSRpM3wc \
--known-validator Certusm1sa411sMpV9FPqU5dXAYhmmhygvxJ23S6hJ24 \
--known-validator 9bkyxgYxRrysC1ijd6iByp9idn112CnYTw243fdH2Uvr \
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
--dynamic-port-range 8001-8020 \
--gossip-port 8001 \
--no-port-check \
--rpc-port 8899 \
--rpc-bind-address 127.0.0.1 \
--private-rpc \
--only-known-rpc\
--full-snapshot-interval-slots 30000 \
--incremental-snapshot-interval-slots 500 \
--maximum-full-snapshots-to-retain 1 \
--maximum-incremental-snapshots-to-retain 2 \
--maximum-local-snapshot-age 1500 \
--wal-recovery-mode skip_any_corrupted_record \
--snapshot-compression none \
--expected-genesis-hash $EXPECTED_GENESIS_HASH \
--no-os-network-limits-test \
--wait-for-supermajority 135986379 \
--no-snapshot-fetch \
--no-genesis-fetch \
--expected-bank-hash DfRg2DQzWVQjRTBSXwTaYgHDPZbQ85ebLrfayJmMENtp \
--log /root/solana/solana.log
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID

[Install]
WantedBy=multi-user.target
```
