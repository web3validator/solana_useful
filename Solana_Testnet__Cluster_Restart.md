

### Instruction is written for an appendics

 Install new version
```
solana-install init v1.18.2
```
stop service, delete ledger
```bash
systemctl stop solana
rm -rf $HOME/solana/ledger/snapshot*
```
download appropriate snapshot
```bash
wget --trust-server-names http://testnet.solana.margus.one/snapshot.tar.bz2 -P $HOME/solana/ledger/
```
change service parameters
```bash
nano /etc/systemd/system/solana.service
```
```
--wait-for-supermajority 254108257 \
--expected-shred-version 35459 \
--expected-bank-hash 4rWEDhTyQVgTw6sPoCthXmUNmjeiwsdKQ5ZNvpEi3uvk \
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
