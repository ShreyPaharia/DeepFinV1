// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { IERC20, ILendingPool, IProtocolDataProvider, IStableDebtToken } from './Interfaces.sol';
import { SafeERC20 } from './Libraries.sol';
import {CashflowTokens} from '../CashflowTokens.sol';
import {ERC1155Holder} from '@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol';

import {
    ISuperfluid,
    ISuperToken,
    ISuperAgreement,
    SuperAppDefinitions
} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";

import {
    IConstantFlowAgreementV1
} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IConstantFlowAgreementV1.sol";

import {
    SuperAppBase
} from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperAppBase.sol";

interface ISDT is ISuperToken {
    function setLendingPoolDF(address lpdf) external;

    function mint(address account, uint256 amount) external;

    function burn(address account, uint256 amount) external;
}

/**
 * This is a proof of concept starter contract, showing how uncollaterised loans are possible
 * using Aave v2 credit delegation.
 * This example supports stable interest rate borrows.
 * It is not production ready (!). User permissions and user accounting of loans should be implemented.
 * See @dev comments
 */
 
contract LendingPoolDF is ERC1155Holder, SuperAppBase{
    using SafeERC20 for IERC20;
    
    ILendingPool constant lendingPool = ILendingPool(address(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9)); // Kovan
    IProtocolDataProvider constant dataProvider = IProtocolDataProvider(address(0x057835Ad21a177dbdd3090bB1CAE03EaCF78Fc6d)); // Kovan

    CashflowTokens cashflowTokens;
    ISDT SDT; // super deposit token
    
    address owner;
    string name="Deep Fin Lending Pool";

    constructor (address _cashflowTokens, address _SDT) {
        owner = msg.sender;
        cashflowTokens = CashflowTokens(_cashflowTokens);
        SDT = ISDT(_SDT);
    }

    /**
     * Deposits collateral into the Aave, to enable credit delegation
     * This would be called by the delegator.
     * @param asset The asset to be deposited as collateral
     * @param amount The amount to be deposited as collateral
     * @param isPull Whether to pull the funds from the caller, or use funds sent to this contract
     *  User must have approved this contract to pull funds if `isPull` = true
     * 
     */
    function depositCollateral(address asset, uint256 amount, bool isPull) public {
        if (isPull) {
            IERC20(asset).safeTransferFrom(msg.sender, address(this), amount);
        }

        IERC20(asset).safeApprove(address(lendingPool), amount);
        lendingPool.deposit(asset, amount, address(this), 0);

        SDT.mint(msg.sender, amount);
    }

    /**
     * Withdraw all of a collateral as the underlying asset, if no outstanding loans delegated
     * @param asset The underlying asset to withdraw
     * 
     * Add permissions to this call, e.g. only the owner should be able to withdraw the collateral!
     */
    function withdrawCollateral(address asset, uint256 amount) public {
        SDT.burn(msg.sender, amount);

        (address aTokenAddress,,) = dataProvider.getReserveTokensAddresses(asset);
        uint256 assetBalance = IERC20(aTokenAddress).balanceOf(address(this));

        lendingPool.withdraw(asset, assetBalance, owner);
    }

    /**
     * Approves the borrower to take an uncollaterised loan
     * @param borrower The borrower of the funds (i.e. delgatee)
     * @param amount The amount the borrower is allowed to borrow (i.e. their line of credit)
     * @param asset The asset they are allowed to borrow
     * 
     * Add permissions to this call, e.g. only the owner should be able to approve borrowers!
     */
    function approveBorrower(address borrower, uint256 amount, address asset, uint256 tokenId) public {
        (, address stableDebtTokenAddress,) = dataProvider.getReserveTokensAddresses(asset);
        //Transfer cashflow tokens 
        cashflowTokens.safeTransferFrom(msg.sender, address(this), tokenId, amount, "Abc");

        //Modify the amount to charge fees
        uint256 loanAmount = (amount*9)/10;

        IStableDebtToken(stableDebtTokenAddress).approveDelegation(borrower, loanAmount);
    }
    
    /**
     * Repay an uncollaterised loan
     * @param amount The amount to repay
     * @param asset The asset to be repaid
     * 
     * User calling this function must have approved this contract with an allowance to transfer the tokens
     * 
     * You should keep internal accounting of borrowers, if your contract will have multiple borrowers
     */
    function repayBorrower(uint256 amount, address asset) public {
        IERC20(asset).safeTransferFrom(msg.sender, address(this), amount);
        IERC20(asset).safeApprove(address(lendingPool), amount);
        lendingPool.repay(asset, amount, 1, address(this));
    }

    function beforeAgreementCreated(
        ISuperToken /*superToken*/,
        address /*agreementClass*/,
        bytes32 /*agreementId*/,
        bytes calldata /*agreementData*/,
        bytes calldata /*ctx*/
    )
        external
        view
        virtual
        override
        returns (bytes memory /*cbdata*/)
    {
        revert("Unsupported callback - Before Agreement Created");
    }

    function afterAgreementCreated(
        ISuperToken /*superToken*/,
        address /*agreementClass*/,
        bytes32 /*agreementId*/,
        bytes calldata /*agreementData*/,
        bytes calldata /*cbdata*/,
        bytes calldata /*ctx*/
    )
        external
        override
        returns (bytes memory /*newCtx*/)
    {
        revert("Unsupported callback - After Agreement Created");
    }

    function beforeAgreementUpdated(
        ISuperToken /*superToken*/,
        address /*agreementClass*/,
        bytes32 /*agreementId*/,
        bytes calldata /*agreementData*/,
        bytes calldata /*ctx*/
    )
        external
        view
        override
        returns (bytes memory /*cbdata*/)
    {
        revert("Unsupported callback - Before Agreement updated");
    }

    function afterAgreementUpdated(
        ISuperToken /*superToken*/,
        address /*agreementClass*/,
        bytes32 /*agreementId*/,
        bytes calldata /*agreementData*/,
        bytes calldata /*cbdata*/,
        bytes calldata /*ctx*/
    )
        external
        override
        returns (bytes memory /*newCtx*/)
    {
        revert("Unsupported callback - After Agreement Updated");
    }

    function beforeAgreementTerminated(
        ISuperToken /*superToken*/,
        address /*agreementClass*/,
        bytes32 /*agreementId*/,
        bytes calldata /*agreementData*/,
        bytes calldata /*ctx*/
    )
        external
        view
        override
        returns (bytes memory /*cbdata*/)
    {
        revert("Unsupported callback -  Before Agreement Terminated");
    }

    function afterAgreementTerminated(
        ISuperToken /*superToken*/,
        address /*agreementClass*/,
        bytes32 /*agreementId*/,
        bytes calldata /*agreementData*/,
        bytes calldata /*cbdata*/,
        bytes calldata /*ctx*/
    )
        external
        override
        returns (bytes memory /*newCtx*/)
    {
        revert("Unsupported callback - After Agreement Terminated");
    }
}
