SHELL := /bin/bash

.PHONY: link-latest
link-latest:
	@echo "Linking latest protocol contracts"
	rm -rf ./node_modules/protocol && cd .. && yarn

.PHONY: copy-deployed-contracts
copy-deployed-contracts:
	@echo "Copying deployed contracts to ./addresses/{CHAIN_ID}"
	make link-latest && yarn tsx ./script/copy-deployed-contracts.ts

.PHONY: deploy-full-suite-sepolia
deploy-full-suite-sepolia:
	@echo "Deploying full suite to base-sepolia"
	make link-latest && forge script ./script/FullSuiteDeploy.s.sol:FullSuiteDeploy --chain base-sepolia --fork-url https://sepolia.base.org --account deployerKey --sender 0x94D9cb3cbdab30140cE9FAA620f81E4cCaaAFDa3  --broadcast --verify -vvvv && make copy-deployed-contracts

.PHONY: deploy-full-suite-mainnet
deploy-full-suite-mainnet:
	@echo "Deploying full suite to base-mainnet"
	make link-latest && forge script ./script/FullSuiteDeploy.s.sol:FullSuiteDeploy --chain base --fork-url https://mainnet.base.org --account deployerKey --sender 0x94D9cb3cbdab30140cE9FAA620f81E4cCaaAFDa3  --broadcast --verify -vvvv && make copy-deployed-contracts

.PHONY: approve-logic
approve-logic-sepolia:
	@echo "Approving dynamic logic on base-sepolia"
	make link-latest && make copy-deployed-contracts && forge script ./script/ApproveDynamicLogicSigs.s.sol:ApproveLogic --chain base-sepolia --fork-url https://sepolia.base.org --account deployerKey --sender 0x94D9cb3cbdab30140cE9FAA620f81E4cCaaAFDa3  --broadcast --verify -vvvv && make copy-deployed-contracts

.PHONY: approve-logic-mainnet
approve-logic-mainnet:
	@echo "Approving dynamic logic on base-mainnet"
	make link-latest && make copy-deployed-contracts && forge script ./script/ApproveDynamicLogicSigs.s.sol:ApproveLogic --chain base --fork-url https://mainnet.base.org --account deployerKey --sender 0x94D9cb3cbdab30140cE9FAA620f81E4cCaaAFDa3  --broadcast --verify -vvvv && make copy-deployed-contracts

.PHONY: upgrade-channels-sepolia
upgrade-channels-sepolia:
	@echo "Upgrading channels on base-sepolia"
	make link-latest && forge script ./script/UpgradeChannels.s.sol:UpgradeChannels --chain base-sepolia --fork-url https://sepolia.base.org --account deployerKey --sender 0x94D9cb3cbdab30140cE9FAA620f81E4cCaaAFDa3 --broadcast --verify -vvvv && make copy-deployed-contracts

.PHONY: upgrade-channels-mainnet
upgrade-channels-mainnet:
	@echo "Upgrading channels on base-mainnet"
	make link-latest && forge script ./script/UpgradeChannels.s.sol:UpgradeChannels --chain base --fork-url https://mainnet.base.org --account deployerKey --sender 0x94D9cb3cbdab30140cE9FAA620f81E4cCaaAFDa3 --broadcast --verify -vvvv && make copy-deployed-contracts
