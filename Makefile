.PHONY: node
node:
	npx hardhat node

.PHONY: deploy
deploy:
	npx hardhat run scripts/deploy.js --network $(NETWORK)

.PHONY: verify
verify:
	npx hardhat verify --network $(NETWORK) $(ADDRESS) $(CONSTRUCTOR_ARGS)