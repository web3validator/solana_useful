#!/usr/bin/env bash

# Instructions for using this script:
# 1) Download the script:
# $ curl https://gist.githubusercontent.com/willhickey/0c90b7929550a08712cd9adeb8b693c1/raw/9daa76365a6522c82541e22ddd1fcb7bf396e587/halt_validator_at_epoch.sh > halt_validator_at_epoch.sh

# 2) Edit the final line of this script: it should be a command that will halt your validator

# 3) Make the script executable: 
# $ chmod 700 halt_validator_at_epoch.sh

# 4) Run this script in a screen session so it keeps running even if your terminal disconnects. 
# Here's an example using the name "halt_579" for the scren session:
# $ screen -S halt_579
# You're now inside the new screen session.

# 5)  Inside the screen session run the script:
# $ ./halt_validator_at_epoch.sh 579

# 6) Disconnect from the screen with Ctrl+a, Ctrl+d. The session is still running in the background. 

# You can list your screen sessions with:
# $ screen -ls
# You can reconnect to the screen session to make sure the script is still running:
# $ screen -r halt_579

if [[ -z $1 ]]; then
  echo "Usage: $0 <epoch>"
  echo "Waits until the specified epoch, then waits for a new snapshot and halts the validator."
  exit 0
fi

epoch_to_halt=$1

while :
do
  current_epoch=$(solana epoch --commitment finalized -ul)
  echo "Waiting until epoch $epoch_to_halt. Current Epoch: $current_epoch"
  if [[ $current_epoch = $epoch_to_halt ]]; then
    echo "$current_epoch is same as $epoch_to_halt. Initiating shutdown procedure."
    break
  elif [[ $current_epoch > $epoch_to_halt ]]; then
    echo "Current epoch $current_epoch is greater than epoch to halt $epoch_to_halt. Bailing out."
    exit 1
  fi

  sleep 600 # poll every 10 minutes
done

# TODO Replace this with a command that will halt your validator
sudo systemctl stop solana
