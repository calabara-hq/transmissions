# Transmissions

### Background
*Transmissions* is a protocol that provides flexible infrastructure for community publishing under a managed ERC1155 collection ("channel").


### Terminology
* Channel - ERC1155 contract
* Transport Layer - Implementations that inherit the base Channel.sol contract which can support different functionality by overriding 3 virtual functions.

### Architecture

Channels are created by calling the channel factory contract. The factory creates a new ERC1967Proxy to one of the channel type implementations (Infinite or Finite). Anyone can create a channel by interacting with the factory.

![image](https://hackmd.io/_uploads/HyzF-134R.png)

The transport layer consists of 2 independent channel modes. Each of the transports enable users to interact with the 1155 collection in different ways.

![image](https://hackmd.io/_uploads/SJZlmJ3NR.png)

Finite Channels accept new tokens, and mints of those tokens, for a fixed period. Finite channels are meant to operate as a contest, in which rewards are escrowed by the admins on initialization and distributed after the contest ends by calling a settle function.

Infinite Channels are much simpler. They accept new tokens indefinitely and don't escrow any rewards.

At a high level, admins and managers are assumed to be trusted parties which define the rules of engagement for the channel. Users visit the channel and either create or mint tokens.

![image](https://hackmd.io/_uploads/ry6eBkn4A.png)

Channel.sol inherits from 3 main contracts:

**Rewards.sol** - handles escrow and minting rewards for channels.

**ChannelStorage.sol** - main storage layout for channels.

**ManagedChannel.sol** - Contract module which provides access control, reentrancy, and upgradeablity mechanisms.

![image](https://hackmd.io/_uploads/r1_JU12EC.png)

In addition, Channel.sol calls to 2 external contracts to manage mint fees and interaction logic.

**Fee Contract** - Custom incentive structure which allows admins / managers to define how mint fees (if any) are distributed to different parties. Mint fees can be set in ETH or ERC20.

**Logic Contract** - Logic which governs the interaction power (num creations / num mints) allotted to users in a channel based on results of external calls to other contracts at runtime.

![image](https://hackmd.io/_uploads/SyBfDkhEC.png)

