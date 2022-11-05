#Stop and rm ledger, and backup service

```bash
systemctl stop solana
solana-install init v1.14.7
rm -rf /root/solana/ledger/
mkdir /root/solana/ledger/
cd /root/solana/ledger/
wget --trust-server-names http://194.126.172.246:8899/snapshot.tar.bz2
wget https://www.shinobi-systems.com/testnet-snapshot-160991176/snapshot-160991176-34QhWFp6afjFWmviBqaAiLbk62w75r18UB6qYqfZ7Wjt.tar.zst
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
--wait-for-supermajority 160991176 \
--expected-shred-version 8135 \
--entrypoint entrypoint.testnet.solana.com:8001 \
--entrypoint entrypoint2.testnet.solana.com:8001 \
--entrypoint entrypoint3.testnet.solana.com:8001 \
--expected-bank-hash GfNNxK4wS51NDWos2DQoLKU2ECiMEbFMPRw7bpDi9BoY \
--known-validator eoKpUABi59aT4rR9HGS3LcMecfut9x7zJyodWWP43YQ \
--known-validator 9v7E6oEm1V86hjTubtBon7cRYPvQriWZKHZEX6j92Po4 \
--known-validator FnpP7TK6F2hZFVnqSUJagZefwRJ4fmnb1StS1NokpLZM \
--known-validator J7v9ndmcoBuo9to2MnHegLnBkC9x3SAVbQBJo5MMJrN1 \
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
