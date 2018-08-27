.PHONY: create destroy unlock hello/install tic-tac-toe/install

create:
	docker run --name eosio -d -p 8888:8888 -p 9876:9876 -v $(CURDIR):/work eosio/eos-dev /bin/bash -c "nodeos -e -p eosio --plugin eosio::producer_plugin --plugin eosio::history_plugin --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin --plugin eosio::http_plugin -d /mnt/dev/data --config-dir /mnt/dev/config --http-server-address=0.0.0.0:8888 --access-control-allow-origin=* --contracts-console --http-validate-host=false"
	docker exec --detach eosio cleos wallet list
	sleep 4
	./bootstrap.sh

destroy:
	docker stop eosio
	docker rm eosio

unlock:
	./cleos.sh wallet unlock --password "$(shell docker exec -it eosio cat /default-wallet-password | tr -d '[:space:"]')"

hello/hello.wast: hello/hello.cpp
	./eosiocpp.sh -o /work/hello/hello.wast /work/hello/hello.cpp

hello/hello.abi: hello/hello.cpp
	./eosiocpp.sh -g /work/hello/hello.abi /work/hello/hello.cpp

hello/install: hello/hello.wast hello/hello.abi
	./cleos.sh set contract hello.code /work/hello -p hello.code@active

tic-tac-toe/tic-tac-toe.abi: tic-tac-toe/tic-tac-toe.hpp
	./eosiocpp.sh -g /work/tic-tac-toe/tic-tac-toe.abi /work/tic-tac-toe/tic-tac-toe.hpp

tic-tac-toe/tic-tac-toe.wast: tic-tac-toe/tic-tac-toe.cpp
	./eosiocpp.sh -o /work/tic-tac-toe/tic-tac-toe.wast /work/tic-tac-toe/tic-tac-toe.cpp

tic-tac-toe/install: tic-tac-toe/tic-tac-toe.wast tic-tac-toe/tic-tac-toe.abi
	./cleos.sh set contract tic.tac.toe /work/tic-tac-toe -p tic.tac.toe@active
