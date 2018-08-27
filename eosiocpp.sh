#!/bin/bash
exec docker exec -it eosio /opt/eosio/bin/eosiocpp "$@"
