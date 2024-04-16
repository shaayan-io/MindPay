# Smart Contract Documentation

## Overview

This documentation provides an overview of a set of smart contracts designed to facilitate investments and staking with the MINDPAY token. The contracts include:

1. **MindpayToken**: An ERC20 token contract with additional minting and burning functionalities.
2. **LiquidityContract**: A contract to handle the addition of liquidity in the form of Ether.
3. **MindpayInvestment**: A contract allowing users to invest Ether, lock their investments, cancel investments, and stake investments for additional benefits.
4. **StakingContract**: A contract allowing users to stake and unstake MINDPAY tokens.

## 1. MindpayToken

The `MindpayToken` contract is an ERC20 token implementation with additional mint and burn functions. It allows for the creation, minting, and burning of tokens.

### Functions

- `constructor()`: Initializes the token with a name and symbol.
- `mint(address _investor, uint256 _amount)`: Mints new tokens and assigns them to the specified address.
- `burn(address _investor, uint256 _amount)`: Burns a specific amount of tokens from the specified address.

## 2. LiquidityContract

The `LiquidityContract` contract allows users to add liquidity in the form of Ether. It maintains a record of liquidity balances for each investment ID.

### Functions

- `receive()`: Fallback function to receive Ether.

## 3. MindpayInvestment

The `MindpayInvestment` contract facilitates investments in MINDPAY tokens. It allows users to invest Ether, lock their investments for a certain period, cancel their investments, and stake their investments for additional benefits.

### Functions

- `constructor(...)`: Initializes the contract with required parameters.
- `invest()`: Allows an investor to make an investment in MINDPAY tokens.
- `cancelInvestment(uint256 id)`: Cancels an investment made by the investor.
- `stakeInvestment(uint256 id)`: Stakes an investment made by the investor.

### Interactions

- Requires interaction with `MindpayToken` contract for minting and burning tokens.
- Requires interaction with `StakingContract` for staking investments.

## 4. StakingContract

The `StakingContract` contract allows users to stake and unstake MINDPAY tokens. It maintains a record of staked balances for each investment ID.

### Functions

- `constructor(MindpayToken _tokenContract)`: Initializes the contract with the MINDPAY token contract address.
- `stake(...)`: Allows users to stake MINDPAY tokens.
- `unstake(...)`: Allows users to unstake previously staked MINDPAY tokens.

### Interactions

- Requires interaction with `MindpayToken` contract for transferring tokens.
