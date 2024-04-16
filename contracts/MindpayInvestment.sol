// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {MindpayToken} from "./MindpayToken.sol"; // Import the MINDPAY token contract
import {StakingContract} from "./StakingContract.sol"; // Import the MINDPAY token contract

/**
 * @title MindpayInvestment
 * @author Shayan
 * @dev The MindpayInvestment contract facilitates investments in MINDPAY tokens.
 *      It allows users to invest Ether, lock their investments for a certain period,
 *      cancel their investments, and stake their investments for additional benefits.
 */
contract MindpayInvestment {

    /////////////////////
    // Errors          //
    /////////////////////
    error MindpayInvestment__InvalidAmount();
    error MindpayInvestment__InvestmentCancelled();
    error MindpayInvestment__LockingPeriodNotEndYet();

    /**
     * @dev The MINDPAY token contract instance.
     */
    MindpayToken public mindpayToken;

    /**
     * @dev The staking contract instance.
     */
    StakingContract public stakingContract;

    /**
     * @dev Address to receive liquidity.
     */
    address payable public liquidityProvider;

    /**
     * @dev Conversion rate: 1 Ether = 1000 MINDPAY tokens.
     */
    uint256 public constant CONVERSION_RATE = 1000;

    /**
     * @dev Lock period for testing purposes.
     */
    uint256 public constant LOCK_PERIOD = 15 minutes;

    /**
     * @dev Investment status enum.
     */
    enum InvestmentStatus {
        Active,
        Canceled,
        Staked
    }

    /**
     * @dev Struct to represent an investment.
     */
    struct Investment {
        address investor; // Investor's address
        uint256 id; // Investment ID
        uint256 amount; // Amount of Ether invested
        uint256 lockedEtherAmount; // Amount of Ether locked for the investment
        uint256 lockedTokensAmount; // Amount of MINDPAY tokens locked for the investment
        uint256 timestamp; // Timestamp when the investment was made
        InvestmentStatus status; // Status of the investment
    }

    /**
     * @dev Mapping to store investment details.
     */
    mapping(uint256 => Investment) public investments;

    /**
     * @dev Total number of investments made.
     */
    uint256 public totalInvestments;

    /**
     * @dev Event emitted when an investment is made.
     */
    event InvestmentMade(uint256 id, address investor, uint256 amount);

    /**
     * @dev Event emitted when tokens are locked.
     */
    event TokensLocked(uint256 id, uint256 amount);

    /**
     * @dev Event emitted when an investment is canceled.
     */
    event InvestmentCanceled(uint256 id, address investor);

    /**
     * @dev Event emitted when an investment is staked.
     */
    event InvestmentStaked(
        uint256 id,
        address investor,
        address stakingContract
    );

    /**
     * @dev Constructor function to initialize the MindpayInvestment contract.
     * @param _tokenContract Address of the MindpayToken contract.
     * @param _liquidityProvider Address to receive liquidity.
     * @param _stakingContract Address of the StakingContract.
     */
    constructor(
        MindpayToken _tokenContract,
        address _liquidityProvider,
        StakingContract _stakingContract
    ) {
        mindpayToken = _tokenContract;
        liquidityProvider = payable(_liquidityProvider);
        stakingContract = _stakingContract;
        totalInvestments = 0;
    }

    /**
     * @dev Allows an investor to make an investment in MINDPAY tokens.
     *
     *
     *
     * Requirements:
     * - The investment amount must be greater than zero.
     *
     * Emits an `InvestmentMade` event upon successful investment, including details such as investment counter, investor address, investment address, amount, and timestamp.
     *
     * Updates the total amount received in the contract.
     */
    function invest() external payable {
        if (msg.value < 0) {
            revert MindpayInvestment__InvalidAmount();
        }

        uint256 investedWei = msg.value;
        uint256 mindpayAmount = (msg.value * CONVERSION_RATE) / 1 ether; // Adjusted for wei;

        if (msg.value >= 1 ether && msg.value < 5 ether) {
            mindpayAmount += (mindpayAmount * 10) / 100; // 10% bonus
        } else if (msg.value >= 5 ether) {
            mindpayAmount += (mindpayAmount * 20) / 100; // 20% bonus
        }

        uint256 lockedEtherAmount = (investedWei * 9) / 10;

        uint256 id = totalInvestments + 1;
        investments[id] = Investment({
            investor: msg.sender,
            id: id,
            amount: investedWei,
            lockedEtherAmount: lockedEtherAmount,
            lockedTokensAmount: mindpayAmount,
            timestamp: block.timestamp,
            status: InvestmentStatus.Active
        });
        totalInvestments += 1;

        payable(liquidityProvider).transfer(investedWei / 10);
        mindpayToken.mint(address(this), mindpayAmount);

        emit InvestmentMade(id, msg.sender, investedWei);
        emit TokensLocked(id, mindpayAmount);
    }

    /**
     * @dev Cancels an investment made by the investor.
     *
     * @param id The ID of the investment to cancel.
     *
     * Requirements:
     * - The investment must be in the 'Active' status.
     * - The lock period must have expired.
     *
     * Emits an `InvestmentCanceled` event upon successful cancellation, including details such as investment ID and investor address.
     *
     * Refunds the locked Ether to the investor.
     */
    function cancelInvestment(uint256 id) external {
        Investment storage investment = investments[id];

        if(investment.status != InvestmentStatus.Active)
        {
            revert MindpayInvestment__InvestmentCancelled(); 
        }
        if(block.timestamp < investment.timestamp + LOCK_PERIOD)
        {
            revert MindpayInvestment__LockingPeriodNotEndYet(); 
        }
       
        uint256 tokenAmount = investment.lockedTokensAmount;

        payable(investment.investor).transfer((investment.amount * 9) / 10);

        mindpayToken.burn(address(this), tokenAmount);

        investment.status = InvestmentStatus.Canceled;

        emit InvestmentCanceled(id, investment.investor);
    }

    /**
     * @dev Stakes an investment made by the investor.
     *
     * @param id The ID of the investment to stake.
     *
     * Requirements:
     * - The investment must be in the 'Active' status.
     * - The lock period must have expired.
     *
     * Emits an `InvestmentStaked` event upon successful staking, including details such as investment ID, investor address, and staking contract address.
     *
     * Transfers the locked Ether to the liquidity provider and approves the staking contract to transfer the locked tokens.
     */
    function stakeInvestment(uint256 id) external {
        Investment storage investment = investments[id];
        if(investment.status != InvestmentStatus.Active)
        {
            revert MindpayInvestment__InvestmentCancelled(); 
        }
        if(block.timestamp < investment.timestamp + LOCK_PERIOD)
        {
            revert MindpayInvestment__LockingPeriodNotEndYet(); 
        }

        payable(liquidityProvider).transfer((investment.amount * 9) / 10);

        mindpayToken.approve(
            address(stakingContract),
            investment.lockedTokensAmount * 10**uint256(mindpayToken.decimals())
        );
        stakingContract.stake(
            address(this),
            id,
            investment.lockedTokensAmount * 10**uint256(mindpayToken.decimals())
        );

        investment.status = InvestmentStatus.Staked;

        emit InvestmentStaked(
            id,
            investment.investor,
            address(stakingContract)
        );
    }
}

