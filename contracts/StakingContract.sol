// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {MindpayToken} from "./MindpayToken.sol"; // Import the MINDPAY token contract

/**
 * @title StakingContract
 * @author Shayan
 * @dev The StakingContract allows users to stake and unstake MINDPAY tokens.
 *      It maintains a record of staked balances for each investment ID.
 * @notice This contract interacts with the MindpayToken contract to transfer tokens for staking and unstaking.
 */
contract StakingContract {
    /////////////////////
    // Errors          //
    /////////////////////
    error StakingContract__InvalidAmount();
    error StakingContract__InsufficientBalance();

    /////////////////////
    // State Variables //
    /////////////////////
    /**
     * @dev The MINDPAY token contract instance.
     */
    MindpayToken public mindpayToken;

    /**
     * @dev Mapping to store staked balances for each investment ID.
     */
    mapping(uint256 => uint256) public stakedBalances;

    /////////////////////
    // Events          //
    /////////////////////
    /**
     * @dev Event emitted when tokens are staked.
     * @param investmentId The ID of the investment for which tokens are staked.
     * @param amount The amount of tokens staked.
     */
    event Staked(uint256 investmentId, uint256 amount);

    /**
     * @dev Event emitted when tokens are unstaked.
     * @param investmentId The ID of the investment for which tokens are unstaked.
     * @param amount The amount of tokens unstaked.
     */
    event Unstaked(uint256 investmentId, uint256 amount);

    ////////////////////////
    // Functions          //
    ////////////////////////
    /**
     * @dev Constructor function to initialize the StakingContract with the MINDPAY token contract address.
     * @param _tokenContract Address of the MindpayToken contract.
     */
    constructor(MindpayToken _tokenContract) {
        mindpayToken = _tokenContract;
    }

    ////////////////////////
    // External Functions //
    ////////////////////////
    /**
     * @dev Allows users to stake MINDPAY tokens.
     * @param from The address from which tokens are being staked.
     * @param investmentId The ID of the investment for which tokens are being staked.
     * @param amount The amount of tokens to stake.
     */
    function stake(
        address from,
        uint256 investmentId,
        uint256 amount
    ) external {
        if (amount < 0) {
            revert StakingContract__InvalidAmount();
        }
        if (mindpayToken.balanceOf(from) < amount) {
            revert StakingContract__InsufficientBalance();
        }

        mindpayToken.transferFrom(from, address(this), amount);
        stakedBalances[investmentId] += amount;

        emit Staked(investmentId, amount);
    }

    ////////////////////////
    // External Functions //
    ////////////////////////
    /**
     * @dev Allows users to unstake previously staked MINDPAY tokens.
     * @param investmentId The ID of the investment from which tokens are being unstaked.
     * @param amount The amount of tokens to unstake.
     */
    function unstake(uint256 investmentId, uint256 amount) external {
        if (amount < 0) {
            revert StakingContract__InvalidAmount();
        }
        if (stakedBalances[investmentId] < amount) {
            revert StakingContract__InsufficientBalance();
        }

        mindpayToken.transfer(msg.sender, amount);
        stakedBalances[investmentId] -= amount;

        emit Unstaked(investmentId, amount);
    }

    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    // External & Public View & Pure Functions ////
    ///////////////////////////////////////////////
    ///////////////////////////////////////////////
    /**
     * @dev Retrieves the staked balance for a specific investment ID.
     * @param investmentId The ID of the investment to query.
     * @return The staked balance for the specified investment ID.
     */
    function stakedBalanceOf(uint256 investmentId)
        external
        view
        returns (uint256)
    {
        return stakedBalances[investmentId];
    }
}
