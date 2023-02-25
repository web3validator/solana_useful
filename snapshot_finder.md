# solana-snapshot-finder
Automatic search and download of snapshots for Solana  



```bash
sudo su
rm -rf ~/solana/ledger
mkdir ~/solana/ledger
cd ~/solana/ledger
wget http://20230225soloutage.s3-website.eu-central-1.amazonaws.com/snapshot-179526408-9kUTC2pYALrYD8rb93E1mY2vG4QG8jCX132Z4CEhBHgJ.tar.zst
rm /etc/systemd/system/solana.service
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
--wait-for-supermajority 179526408 \
--expected-shred-version 12743 \
--expected-bank-hash JCfD7vqjQWKV8Vusx7degWczh55WkQ2cEifGTzCkXdKk \
--known-validator CMPSSdrTnRQBiBGTyFpdCc3VMNuLWYWaSkE8Zh5z6gbd \
--known-validator 6WgdYhhGE53WrZ7ywJA15hBVkw7CRbQ8yDBBTwmBtAHN \
--known-validator 7Np41oeYqPefeNQEHSv1UDhYrehxin3NStELsSKCT4K2 \
--known-validator GwHH8ciFhR8vejWCqmg8FWZUCNtubPY2esALvy5tBvji \
--known-validator Ninja1spj6n9t5hVYgF3PdnYz2PLnkt7rvaw3firmjs \
--known-validator PUmpKiNnSVAZ3w4KaFX6jKSjXUNHFShGkXbERo54xjb \
--known-validator DE1bawNcRJB9rVm3buyMVfr8mBEoyyu73NBovf2oXJsJ \
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











## Navigation  

  
Install requirements  
```bash
sudo apt-get update \
&& sudo apt-get install python3-venv git -y \
&& git clone https://github.com/c29r3/solana-snapshot-finder.git \
&& cd solana-snapshot-finder \
&& python3 -m venv venv \
&& source ./venv/bin/activate \
&& pip3 install -r requirements.txt
```

Start script  
Mainnet  
```python
python3 snapshot-finder.py --snapshot_path /ledger
sudo su
systemctl restart solana
tail -f ~/solana/solana.log
``` 
```python
python3 snapshot-finder.py --snapshot_path $HOME/solana/ledger
sudo su
systemctl restart solana
tail -f ~/solana/solana.log
``` 
`$HOME/solana/ledger/` - path to your `validator-ledger`


TdS  
```python
python3 snapshot-finder.py --snapshot_path /root/solana/ledger -r http://api.testnet.solana.com
sudo su
systemctl restart solana
tail -f ~/solana/solana.log
``` 

### Run via docker  
Mainnet  
```bash
docker pull c29r3/solana-snapshot-finder:latest; \
sudo docker run -it --rm \
-v ~/solana/validator-ledger:/solana/snapshot \
--user $(id -u):$(id -g) \
c29r3/solana-snapshot-finder:latest \
--snapshot_path /solana/snapshot
```
*`~/solana/validator-ledger` - path to validator-ledger, where snapshots stored*

TdS  
```bash
docker pull c29r3/solana-snapshot-finder:latest; \
sudo docker run -it --rm \
-v ~/solana/validator-ledger:/solana/snapshot \
--user $(id -u):$(id -g) \
c29r3/solana-snapshot-finder:latest \
--snapshot_path /solana/snapshot \
-r http://api.testnet.solana.com
```

## Update  
`docker pull c29r3/solana-snapshot-finder:latest`
