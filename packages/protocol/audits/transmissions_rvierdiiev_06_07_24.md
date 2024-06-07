# Overview

This security review for `transmissions protocol` was done by `rvierdiiev`. Report was created on 07.06.24. During the review source code was checked for security vulnerabilities and design issues.

# Scope

Code review was done for commit: [a00798341f63141bc1bb3a0135dd749daf50983a](https://github.com/calabara-hq/transmissions/commit/a00798341f63141bc1bb3a0135dd749daf50983a).

Fixes review was done for commit: [05e3d5cd672e24e3bba30ba0bf50753e0cdc085f](https://github.com/calabara-hq/transmissions/commit/05e3d5cd672e24e3bba30ba0bf50753e0cdc085f).

Contracts in scope:
- transmissions/packages/protocol/src/*

# Severity Criteria

The severity of disclosed vulnerabilities was evaluated according to a methodology based on [OWASP standards](https://owasp.org/www-community/OWASP_Risk_Rating_Methodology).

Vulnerabilities are divided into three primary risk categories: high, medium, and low/non-critical.

# Summary

During security review were found: 
- 5 medium severity issue/s
- 2 non-critical issue/s

# Detailed Findings

## Medium Risk Findings (5)

### [M-01] ERC20 rewards can't be provided to the finite channel on creation

`ChannelFactory.createFiniteChannel()` function allows anyone to deploy new `FiniteChannel`. First, proxy is deployed and then it is initialized.

```solidity
function _initializeContract(
    address newContract,
    string calldata uri,
    address defaultAdmin,
    address[] calldata managers,
    bytes[] calldata setupActions,
    bytes calldata transportConfig
)
    private
{
    emit SetupNewContract(newContract, uri, defaultAdmin, managers, transportConfig);
    IChannel(newContract).initialize(uri, defaultAdmin, managers, setupActions, transportConfig);
}
```

During the initialization, `Channel.setTransportConfig()` function is called and in case of `FiniteChannel` it allows
creator to top it up with rewards. Rewards can be provided in native token or other ERC20 token.
```solidity
function setTransportConfig(bytes calldata data) public payable override onlyAdminOrManager onlyInitializing {
    ...
    _depositToEscrow(_params.rewards.token, _params.rewards.totalAllocation);
}
```

During the deposit in case if rewards token is native token, then `msg.value` should be equal to total amount. In case of other ERC20 token, caller should provide allowance for channel to transfer tokens to escrow.
```solidity
function _depositToEscrow(address token, uint256 amount) internal {
    _validateIncomingValue(token, amount);

    if (!token.isNativeToken()) {
        erc20Balances[token] += amount;
        _transferExternalERC20(address(this), amount, token);
    }
}
```

The problem is that `ChannelFactory.createFiniteChannel()` function doesn't transfer tokens from creator and also doesn't provide allowance to the channel. Because of that, when channel tries to get tokens from caller, which is factory in this case, the call will revert as factory didn't provide allowance and doesn't have enough funds.

**Recommendation**</br> 
You can make factory transfer tokens directly from creator to the channel and then just log balance increasing in the channel.
Or you can make factory transfer funds to itself from creator, then provide allowance to the channel to transfer tokens to it.

**Status**</br> 
Fixed.

### [M-02] Native rewards can't be provided to the finite channel on creation

`ChannelFactory.createFiniteChannel()` function allows anyone to deploy new `FiniteChannel`. First, proxy is deployed and then it is initialized.

```solidity
function _initializeContract(
    address newContract,
    string calldata uri,
    address defaultAdmin,
    address[] calldata managers,
    bytes[] calldata setupActions,
    bytes calldata transportConfig
)
    private
{
    emit SetupNewContract(newContract, uri, defaultAdmin, managers, transportConfig);
    IChannel(newContract).initialize(uri, defaultAdmin, managers, setupActions, transportConfig);
}
```

During the initialization, `Channel.setTransportConfig()` function is called and in case of `FiniteChannel` it allows
creator to top it up with rewards. Rewards can be provided in native token or other ERC20 token.
```solidity
function setTransportConfig(bytes calldata data) public payable override onlyAdminOrManager onlyInitializing {
    ...
    _depositToEscrow(_params.rewards.token, _params.rewards.totalAllocation);
}
```

During the deposit in case if rewards token is native token, then `msg.value` should be equal to total amount. In case of other ERC20 token, caller should provide allowance for channel to transfer tokens to escrow.
```solidity
function _depositToEscrow(address token, uint256 amount) internal {
    _validateIncomingValue(token, amount);

    if (!token.isNativeToken()) {
        erc20Balances[token] += amount;
        _transferExternalERC20(address(this), amount, token);
    }
}
```

The problem is that `ChannelFactory.createFiniteChannel()` function is not payable, which means that creator can't provide funds in native token along with the call and thus can't deploy channel with native rewards.

**Recommendation**</br> 
Add `payable` modifier to `ChannelFactory.createFiniteChannel()` function and pass `msg.value` with `IChannel.initialize()` call.

**Status**</br> 
Fixed.

### [M-03] FiniteChannel minting and token creation checks are not strict enough, breaking competition rules

FiniteChannel owners provide time periods when creating of tokens and minting of tokens is allowed.
```solidity
function _validateTimingParameters(uint80 _createStart, uint80 _mintStart, uint80 _mintEnd) internal pure {
    if (_createStart >= _mintStart || _mintStart >= _mintEnd) {
        revert InvalidTiming();
    }
}
```
`_mintStart` is the timestamp, when creating of tokens is already forbidden and minting is allowed and `_mintEnd` is when minting is not allowed anymore.

For any new created token `_transportProcessNewToken()` function is called. This function checks if token creation is still allowed.
```solidity
function _transportProcessNewToken(uint256 tokenId) internal override {
    ...

    if (block.timestamp < finiteChannelParams.createStart || block.timestamp > finiteChannelParams.mintStart) {
        revert NotAcceptingCreations();
    }
}
```
The check in the function is not strict enough, which allows new token to be created when `block.timestamp == finiteChannelParams.mintStart`, which breaks competition rules.

For any new token mint `_transportProcessMint()` function is called. This function checks if minting is still allowed.
```solidity
function _transportProcessMint(uint256 tokenId) internal override {
    ...

    if (block.timestamp < finiteChannelParams.mintStart || block.timestamp > finiteChannelParams.mintEnd) {
        revert NotAcceptingMints();
    }

    ...
}
```

As you can see, it allows new tokens to be minted at `block.timestamp == finiteChannelParams.mintEnd`, which breaks competition rules.

**Recommendation**</br> 
- Apply changes to `_transportProcessNewToken()` function
```solidity
if (block.timestamp < finiteChannelParams.createStart || block.timestamp >= finiteChannelParams.mintStart) {
    revert NotAcceptingCreations();
}
```
- Apply changes to `_transportProcessMint()` function
```solidity
if (block.timestamp < finiteChannelParams.mintStart || block.timestamp >= finiteChannelParams.mintEnd) {
    revert NotAcceptingMints();
}
```

**Status**</br> 
Fixed.

### [M-04] Node may be wiped up from channel winners

FiniteChannel provides rewards for tokens according to the amount of mints and rankings. When new token of collection is minted, then `_transportProcessMint()` function is called, which should sort tokens according to the updated minted amount.

In case if token is already registered as node, then `_promoteNode()` is called.
```solidity
function _processIncoming(uint256 tokenId) internal {
    ...

    if (nodes[id].tokenId == tokenId) {
        _promoteNode(tokenId, id);
        return;
    }

    ...
}
```
This function removes node and then loops through all other registered nodes to insert token in correct position. It starts looping from `head` node and finishes when next node is 0.
```solidity
function _promoteNode(uint256 tokenId, bytes32 promotedNodeKey) internal {
    Node memory promotedNode = nodes[promotedNodeKey];
    _removeNode(promotedNodeKey);

    bytes32 currentId = head;
    while (currentId != 0x00) {
        ...
    }
}
```

There is one case when only 1 node is currently registered and new tokens of that node are minted, then when node is removed, we have both `head` and `tail` set to `0`. As result we will not go inside `while` loop and node will not be registered again and will lose position and may lose awards.

Because probability of such case is not high, the severity is chosen as medium.

**Recommendation**</br> 
You can do nothing in case if only 1 node is present.
```solidity
function _promoteNode(uint256 tokenId, bytes32 promotedNodeKey) internal {
    if (length == 1) return;

    Node memory promotedNode = nodes[promotedNodeKey];
    _removeNode(promotedNodeKey);

    bytes32 currentId = head;
    while (currentId != 0x00) {
        ...
    }
}
```

**Status**</br> 
Fixed.

### [M-05] Awarding may be messed up because of wrong ranks config

During `FiniteChannel` deployment `setTransportConfig()` function is called, where deployer provides configuration for the competition.

Inside rewards param owner provides `ranks` array, which contains places in the leaderboard that will get awards. For example `ranks` [1, 3, 5] means that first, third and fifth place will be awarded.

After competition is finished, then anyone can `settle()` and `_getWinners()` function is called to fetch winners' addresses.
```solidity
function _getWinners() internal view returns (address[] memory) {
    address[] memory winners = new address[](finiteChannelParams.rewards.ranks.length);

    bytes32 currentNodeKey = head;
    uint256 currentRankIndex = 0;
    uint256 counter = 1;

    while (currentNodeKey != 0x00 && currentRankIndex < finiteChannelParams.rewards.ranks.length) {
        Node memory currentNode = nodes[currentNodeKey];
        if (counter == finiteChannelParams.rewards.ranks[currentRankIndex]) {
            winners[currentRankIndex] = tokens[currentNode.tokenId].author;
            currentRankIndex++;
        }
        currentNodeKey = currentNode.next;
        counter++;
    }

    return winners;
}
```
This function uses `counter` variable to store position on the leaderboard that is currently being processed. It is incremented every time.
Because of that in case if `ranks` param is provided with incorrect ordering like [3,5,1], then first place will never get the awards.

This can be triggered accidentally or can be used by malicious owners to not pay rewards.

**Recommendation**</br> 
Validate `ranks` array to be ascended and without duplicates.

**Status**</br> 
Fixed.

## Low (2)

### [L-01] Owner can frontrun with token price changing

`Channel.setFees()` can be called by owner or admin any time. This function allows to provide fees configurations and also prices for tokens minting.
Functions that allow token minting for ERC20 don't have any price protection, which means that owner can frontrun such tx, to change erc20 price of token. As result user will pay more for the minting.

This is considered as low issue, because this code is planned to be deployed on Base and Optimism chains only.

**Recommendation**</br> 
Additional param can be added, where user can provide max amount he would like to pay.

**Status**</br> 
Acknowledged.

### [L-02] FiniteChannel admins can withdraw escrowed funds anytime

`FiniteChannel.withdrawRewards()` function allows admins to withdraw funds, that are escrowed for competition at any time, even if competition is ongoing already.

**Recommendation**</br> 
Consider to forbid withdrawing, after `createStart` timestamp. In case if admin made a mistake, he has a time until `createStart` to withdraw. After channel is setlled, then admins should be able to witdraw as well.

**Status**</br> 
Acknowledged.

# Disclosures

Security review does not provide any guarantee or warranty regarding the security of this project. All smart contract software should be used at the sole risk and responsibility of users.
