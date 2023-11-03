include .env

.PHONY: simulate
simulate:
	forge script $(TARGET) --rpc-url ${MUMBAI_RPC_ENDPOINT}

.PHONY: deploy_local
deploy_local:
	forge script $(TARGET) --fork-url http://localhost:8545 --broadcast

.PHONY: deploy
deploy:
	forge script $(TARGET) --rpc-url ${MUMBAI_RPC_ENDPOINT} --etherscan-api-key ${ETHERSCAN_API_KEY} --broadcast --verify

.PHONY: test
test:
	forge test -vvvv --gas-report