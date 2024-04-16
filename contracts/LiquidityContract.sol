// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

/**
 * @title LiquidityContract
 * @author Shayan
 * @dev The LiquidityContract allows users to add liquidity in the form of Ether.
 *      It maintains a record of liquidity balances for each investment ID.
 */
contract LiquidityContract {
    /////////////////////
    // Errors          //
    /////////////////////
    error Investment__InvalidAmount();

    /**
     * @dev Event emitted when liquidity is added.
     * @param investor The address of the investor who added the liquidity.
     * @param amount The amount of Ether added as liquidity.
     */
    event LiquidityAdded(address investor, uint256 amount);


    /**
     * @dev Fallback function to receive Ether.
     */
    receive() external payable {
        if(msg.value <= 0)
        {
            revert Investment__InvalidAmount();
        }
        emit LiquidityAdded(msg.sender, msg.value);
    }
}
