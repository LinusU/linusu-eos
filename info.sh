#!/bin/bash

PASSWORD="$(docker exec -it eosio cat /default-wallet-password | tr -d '[:space:]' | sed -e 's/^"//' -e 's/"$//')"
echo "Password: $PASSWORD"

PRIVATE_KEY="$(docker exec -it eosio head -n 1 /default-key | cut -c 14- | tr -d '[:space:]')"
echo "Private Key: $PRIVATE_KEY"

ACCOUNT_NAME="$(docker exec -it eosio cat /account-name)"
echo "Account Name: $ACCOUNT_NAME"
