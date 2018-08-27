#!/bin/bash

# Create default wallet
./cleos.sh wallet create --file=/default-wallet-password

# Read out password
PASSWORD="$(docker exec -it eosio cat /default-wallet-password | tr -d '[:space:]' | sed -e 's/^"//' -e 's/"$//')"
echo "Password: $PASSWORD"

# Unlock default wallet
# ./cleos.sh wallet unlock --password "$PASSWORD"

# Import Tutorial Key
./cleos.sh wallet import --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3

# Load BIOS Contract
./cleos.sh set contract eosio contracts/eosio.bios -p eosio@active

# Create Key
./cleos.sh create key --file=/default-key

# Read Out Key
PRIVATE_KEY="$(docker exec -it eosio head -n 1 /default-key | cut -c 14- | tr -d '[:space:]')"
echo "Private Key: $PRIVATE_KEY"

# Import Key
ACCOUNT_NAME="$(./cleos.sh wallet import --private-key "$PRIVATE_KEY" | cut -c 27- | tr -d '[:space:]')"
docker exec -it eosio bash -c 'echo -n "'"$ACCOUNT_NAME"'" > /account-name'
echo "Account Name: $ACCOUNT_NAME"

# Create Accounts
./cleos.sh create account eosio user "$ACCOUNT_NAME"
./cleos.sh create account eosio tester "$ACCOUNT_NAME"

# Load Token Contract
# https://developers.eos.io/eosio-cpp/docs/token-tutorial#section-eosio-token-exchange-and-eosio-msig-contracts
./cleos.sh create account eosio eosio.token "$ACCOUNT_NAME"
./cleos.sh set contract eosio.token contracts/eosio.token -p eosio.token@active
./cleos.sh push action eosio.token create '[ "eosio", "1000000000.0000 SYS"]' -p eosio.token@active
./cleos.sh push action eosio.token issue '[ "user", "100.0000 SYS", "memo" ]' -p eosio@active
./cleos.sh push action eosio.token transfer '[ "user", "tester", "25.0000 SYS", "m" ]' -p user@active

# Deploy Exchange Contract
# https://developers.eos.io/eosio-cpp/docs/token-tutorial#section-deploy-exchange-contract
./cleos.sh create account eosio exchange "$ACCOUNT_NAME"
./cleos.sh set contract exchange contracts/exchange -p exchange@active

# Deploy Eosio.msig Contract
# https://developers.eos.io/eosio-cpp/docs/token-tutorial#section-deploy-eosio-msig-contract
./cleos.sh create account eosio eosio.msig "$ACCOUNT_NAME"
./cleos.sh set contract eosio.msig contracts/eosio.msig -p eosio.msig@active

# Create Hello User
./cleos.sh create account eosio hello.code "$ACCOUNT_NAME"

# Create Tic Tac Toe User
./cleos.sh create account eosio tic.tac.toe "$ACCOUNT_NAME"
