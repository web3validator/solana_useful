

```
solana-install init v1.14.23
```
```bash
solana-ledger-tool --ledger /root/solana/ledger create-snapshot \
--snapshot-archive-path  /root/solana/ledger/snapshot \
--hard-fork 213932255 \
--remove-account \
3NKRSwpySNwD3TvP5pHnRmkAQRsdkXWRr1WaQh8p4PWX \
3uFHb9oKdGfgZGJK9EHaAXN4USvnQtAFC13Fh5gGFS5B \
5GpmAKxaGsWWbPp4bNXFLJxZVvG92ctxf7jQnzTQjF3n \
5Pecy6ie6XGm22pc9d4P9W5c31BugcFBuy6hsP2zkETv \
7Vced912WrRnfjaiKRiNBcbuFw7RrnLv3E3z95Y4GTNc \
7rcw5UtqgDTBBv2EcynNfYckgdAaH1MAsCjKgXMkN7Ri \
8199Q2gMD2kwgfopK5qqVWuDbegLgpuFUFHCcUJQDN8b \
86HpNqzutEZwLcPxS6EHDcMNYWk6ikhteg9un7Y2PBKE \
8Zs9W7D9MpSEtUWSQdGniZk2cNmV22y6FLJwCx53asme \
9LZdXeKGeBV6hRLdxS1rHbHoEUsKqesCC2ZAPTPKJAbK \
9gxu85LYRAcZL38We8MYJ4A9AwgBBPtVBAqebMcT1241 \
A16q37opZdQMCbe5qJ6xpBB9usykfv8jZaMkxvZQi4GJ \
CE2et8pqgyQMP2mQRg3CgvX8nJBKUArMu3wfiQiQKY1y \
Cdkc8PPTeTNUPoZEfCY5AyetUrEdkZtNPMgz58nqyaHD \
CveezY6FDLVBToHDcvJRmtMouqzsmj4UXYh5ths5G5Uv \
DdLwVYuvDz26JohmgSbA7mjpJFgX5zP2dkp8qsF2C33V \
EYVpEP7uzH1CoXzbD6PubGhYmnxRXPeq3PPsm1ba3gpo \
EfhYd3SafzGT472tYQDUc4dPd2xdEfKs5fwkowUgVt4W \
Fab5oP3DmsLYCiQZXdjyqT3ukFFPrsmqhXU4WU1AWVVF \
Ff8b1fBeB86q8cjq47ZhsQLgv5EkHu3G1C99zjUfAzrq \
G6vbf1UBok8MWb8m25ex86aoQHeKTzDKzuZADHkShqm6 \
GDH5TVdbTPUpRnXaRyQqiKUa7uZAbZ28Q2N9bhbKoMLm \
GQALDaC48fEhZGWRj9iL5Q889emJKcj3aCvHF7VCbbF4 \
GmuBvtFb2aHfSfMXpuFeWZGHyDeCLPS79s48fmCWCfM5 \
J4HFT8usBxpcF63y46t1upYobJgChmKyZPm5uTBRg25Z \
SVn36yVApPLYsa8koK3qUcy14zXDnqkNYWyUh1f4oK1  \
--  213932255 /root/solana/ledger/snapshot
```

```bash
rm /etc/systemd/system/solana.service
nano /etc/systemd/system/solana.service
```
[Unit]
Description=Solana Node
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
--no-incremental-snapshots \
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
