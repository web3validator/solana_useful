# solana-snapshot-finder
Automatic search and download of snapshots for Solana  
```bash
systemctl stop solana
```

## Navigation  

  
Install requirements  
```bash
rm -rf solana-snapshot-finder

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
python3 snapshot-finder.py --snapshot_path $HOME/solana/ledger --with_private_rpc --num_of_retries 100 && systemctl restart solana
solana catchup --our-localhost
``` 
`$HOME/solana/ledger/` - path to your `validator-ledger`

with min download speed

`python3 snapshot-finder.py --snapshot_path $HOME/solana/ledger --with_private_rpc --num_of_retries 100 --min_download_speed 16 && systemctl restart solana
`


TdS  
```python
python3 snapshot-finder.py --snapshot_path /root/solana/ledger -r http://api.testnet.solana.com && systemctl restart solana
solana catchup --our-localhost
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
