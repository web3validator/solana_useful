
# Mainnet


```bash
sudo su
solana-install init v1.14.23
solana-ledger-tool --ledger <ledger-path> create-snapshot \

--snapshot-archive-path  /root/solana/ledger \

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

--  213932255 /root/solana/ledger
```

```bash
rm /etc/systemd/system/solana.service
nano /etc/systemd/system/solana.service
```

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
LimitNOFILE=1000000
Environment="SOLANA_METRICS_CONFIG="host=https://metrics.solana.com:8086,db=mainnet-beta,u=mainnet-beta_write,p=password""
Environment="EXPECTED_GENESIS_HASH=5eykt4UsFv8P8NJdTREpY1vzqKqZKvdpKuc147dw2N9d"
ExecStart=/root/.local/share/solana/install/active_release/bin/solana-validator \
--entrypoint entrypoint.mainnet-beta.solana.com:8001 \
--entrypoint entrypoint2.mainnet-beta.solana.com:8001 \
--entrypoint entrypoint3.mainnet-beta.solana.com:8001 \
--entrypoint entrypoint4.mainnet-beta.solana.com:8001 \
--entrypoint entrypoint5.mainnet-beta.solana.com:8001 \



--wait-for-supermajority 179526403 \
--expected-shred-version 56177 \
--expected-bank-hash 69p75jzzT1P2vJwVn3wbTVutxHDcWKAgcbjqXvwCVUDE \
--known-validator DE1bawNcRJB9rVm3buyMVfr8mBEoyyu73NBovf2oXJsJ \
--known-validator GdnSyH3YtwcxFvQrVVJMm1JhTS4QVX7MFsX56uJLUfiZ \
--known-validator CakcnaRDHka2gXyfbEd2d3xsvkJkqsLw2akB3zsN1D2S \
--known-validator C1ocKDYMCm2ooWptMMnpd5VEB2Nx4UMJgRuYofysyzcA \
--known-validator GwHH8ciFhR8vejWCqmg8FWZUCNtubPY2esALvy5tBvji \
--known-validator 6WgdYhhGE53WrZ7ywJA15hBVkw7CRbQ8yDBBTwmBtAHN \
--known-validator 7Np41oeYqPefeNQEHSv1UDhYrehxin3NStELsSKCT4K2 \
--no-snapshot-fetch \
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
--log /root/solana/solana.log
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID

[Install]
WantedBy=multi-user.target
```


```bash
systemctl daemon-reload
systemctl restart solana
tail -f ~/solana/solana.log | grep 'Waiting for'
```





# TESTNET

#Stop and rm ledger, and backup service

```bash
systemctl stop solana
solana-install init v1.14.7
rm -rf /root/solana/ledger/
mkdir /root/solana/ledger/
cd /root/solana/ledger/
wget --trust-server-names http://194.126.172.246:8899/snapshot.tar.bz2
wget http://api.testnet.solana.com/genesis.tar.bz2
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
--wait-for-supermajority 161660256 \
--expected-shred-version 6995 \
--entrypoint entrypoint.testnet.solana.sergo.dev:8001 \
--entrypoint tsolv.im-0.net:8000 \
--entrypoint entrypoint.testnet.solana.com:8001 \
--entrypoint entrypoint2.testnet.solana.com:8001 \
--entrypoint entrypoint3.testnet.solana.com:8001 \
--expected-genesis-hash 4uhcVJyU9pJkvQyS88uRDiswHXSCkY3zQawwpjk2NsNY \
--expected-bank-hash GjU2DYkVVcd4LD3Yew1xSL8XibvVnhVse2U6b5JdNDhN \
--known-validator eoKpUABi59aT4rR9HGS3LcMecfut9x7zJyodWWP43YQ \
--known-validator 5D1fNXzvv5NjV1ysLjirC4WY92RNsVH18vjmcszZd8on \
--known-validator td2GGWDsCJ6LvjN89oLJvmrDwE14neNrbqQ9s3tVkPy \
--known-validator td3n5NGhP7JKWrL638gzau3NY7mF4K3ztZww3GkpywJ  \
--known-validator FnpP7TK6F2hZFVnqSUJagZefwRJ4fmnb1StS1NokpLZM \
--known-validator BFquPCAYdjN9QyLVfuGrQdJTF9Ct7Z85FDxhFeLcpFqR \
--no-snapshot-fetch \
--only-known-rpc \
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
