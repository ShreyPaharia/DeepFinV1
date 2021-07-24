// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";

interface IDepositToken is IERC1155 {
  /**
   * @dev Emitted after the mint action
   * @param from The address performing the mint
   * @param value The amount being
   * @param tokenId The new liquidity tokenId of the reserve
   **/
  event Mint(address indexed from, uint256 value, uint256 tokenId);

  /**
   * @dev Mints `amount` aTokens to `user`
   * @param user The address receiving the minted tokens
   * @param amount The amount of tokens getting minted
   * @param asset The new liquidity tokenId of the reserve
   * @return `true` if the the previous balance of the user was 0
   */
  function mint(
    address user,
    uint256 amount,
    address asset


  ) external returns (bool);

  /**
   * @dev Emitted after aTokens are burned
   * @param from The owner of the aTokens, getting them burned
   * @param target The address that will receive the underlying
   * @param value The amount being burned
   * @param tokenId The new liquidity tokenId of the reserve
   **/
  event Burn(address indexed from, address indexed target, uint256 value, uint256 tokenId);

  /**
   * @dev Emitted during the transfer action
   * @param from The user whose tokens are being transferred
   * @param to The recipient
   * @param value The amount being transferred
   * @param tokenId The new liquidity tokenId of the reserve
   **/
  event BalanceTransfer(address indexed from, address indexed to, uint256 value, uint256 tokenId);

  /**
   * @dev Burns aTokens from `user` and sends the equivalent amount of underlying to `receiverOfUnderlying`
   * @param user The owner of the aTokens, getting them burned
   * @param receiverOfUnderlying The address that will receive the underlying
   * @param amount The amount being burned
   * @param asset The new liquidity tokenId of the reserve
   **/
  function burn(
    address user,
    address receiverOfUnderlying,
    uint256 amount,
    address asset

  ) external returns(bool);

  /**
   * @dev Transfers the underlying asset to `target`. Used by the LendingPool to transfer
   * assets in borrow(), withdraw() and flashLoan()
   * @param user The recipient of the aTokens
   * @param amount The amount getting transferred
   * @return The amount transferred
   **/
  // function transferUnderlyingTo(address user, uint256 amount) external returns (uint256);
}
