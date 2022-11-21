```bash
solana-keygen new -o stake.json
```

```bash
solana create-stake-account stake.json 10
```

```bash
solana delegate-stake stake.json ~/solana/vote-account-keypair.json
```
