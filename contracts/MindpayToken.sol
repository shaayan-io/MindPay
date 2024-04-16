// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

/**
 * @title MindpayToken
 * @author Shayan
 * @dev The MindpayToken contract is an ERC20 token implementation with additional mint and burn functions.
 *      It allows for the creation, minting, and burning of tokens.
 * @notice This contract inherits from the ERC20 contract provided by OpenZeppelin and extends its functionality.
 */

contract MindpayToken is ERC20 {

    ////////////////////////
    // Functions          //
    ////////////////////////
    /**
     * @dev Constructor that initializes the token with a name and symbol.
     */
    constructor() ERC20("MINDPAY", "MIND") {}

    ////////////////////////
    // Public Functions   //
    ////////////////////////
    /**
     * @dev Mints new tokens and assigns them to the specified address.
     * @param _investor The address to which the minted tokens will be assigned.
     * @param _amount The amount of tokens to mint.
     */
    function mint(address _investor, uint256 _amount) public 
    {
        _mint(_investor, _amount * 10 ** uint(decimals()));
    }

    /**
     * @dev Burns a specific amount of tokens from the specified address.
     * @param _investor The address from which the tokens will be burned.
     * @param _amount The amount of tokens to burn.
     */
    function burn(address _investor, uint256 _amount) public 
    {
        _burn(_investor, _amount * 10 ** uint(decimals()));
    }
}

