// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {
    ISuperToken,
    CustomSuperTokenProxyBase
}
from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/CustomSuperTokenProxyBase.sol";
import { INativeSuperTokenCustom } from "@superfluid-finance/ethereum-contracts/contracts/interfaces/tokens/INativeSuperToken.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SuperDepositToken is 
    INativeSuperTokenCustom,
    CustomSuperTokenProxyBase
    {

    // string public name = "Deposit Tokens";
    // string public symbol = "dToken";
    mapping (address => DepositMetaData) public depositMetaData;

    function initialize(string calldata name, string calldata symbol, uint256 initialSupply)
        external override
    {
        ISuperToken(address(this)).initialize(
            IERC20(address(0)), // no underlying/wrapped token
            18, // shouldn't matter if there's no wrapped token
            name,
            symbol
        );
        ISuperToken(address(this)).selfMint(msg.sender, initialSupply, new bytes(0));
    }

    struct DepositMetaData {
        uint256  totalSupply;
        address  UNDERLYING_ANCHOR_ADDRESS;
        address  RESERVE_TREASURY_ADDRESS;
        // ILendingPool  POOL;
    }

    function initializeNewPool(
        uint256 _amount,
        address _UNDERLYING_ANCHOR_ADDRESS,
        address _RESERVE_TREASURY_ADDRESS
        // ILendingPool _POOL

    ) public returns(bool){
        DepositMetaData memory lastTokenMetaData = DepositMetaData(_amount,_UNDERLYING_ANCHOR_ADDRESS,_RESERVE_TREASURY_ADDRESS);
        return true;
    }

}