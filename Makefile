.PHONY: create destroy

create:
	docker run --name eosio -d -p 8888:8888 -p 9876:9876 -v $(CURDIR):/work eosio/eos-dev /bin/bash -c "nodeos -e -p eosio --plugin eosio::producer_plugin --plugin eosio::history_plugin --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin --plugin eosio::http_plugin -d /mnt/dev/data --config-dir /mnt/dev/config --http-server-address=0.0.0.0:8888 --access-control-allow-origin=* --contracts-console --http-validate-host=false"
	docker exec --detach eosio cleos wallet list
	sleep 4
	./bootstrap.sh

destroy:
	docker stop eosio
	docker rm eosio
