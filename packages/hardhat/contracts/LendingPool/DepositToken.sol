pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./IDepositToken.sol";
// import "./ILendingPool.sol";

contract DepositToken is ERC1155, IDepositToken {

    struct DepositMetaData {
        uint256  totalSupply;
        address  UNDERLYING_ANCHOR_ADDRESS;
        address  RESERVE_TREASURY_ADDRESS;
        uint256 TOKEN_ID;
        // ILendingPool  POOL;
    }

    string public name = "Deposit Tokens";
    string public symbol = "dToken";
    uint256 public lastTokenId;
    address public owner;
    mapping (address => DepositMetaData) public depositMetaData;

    constructor(string memory _uri) ERC1155(_uri){

        lastTokenId = 0;
        owner = msg.sender;
    }

    function initializeNewPool(
        uint256 _amount,
        address _UNDERLYING_ANCHOR_ADDRESS,
        address _RESERVE_TREASURY_ADDRESS,
        address _UNDERLYING_ASSET_ADDRESS//,
        // ILendingPool _POOL

    ) public returns(bool){
        lastTokenId++;
        DepositMetaData memory lastTokenMetaData = DepositMetaData(_amount,_UNDERLYING_ANCHOR_ADDRESS,_RESERVE_TREASURY_ADDRESS,lastTokenId);
        depositMetaData[_UNDERLYING_ASSET_ADDRESS] = lastTokenMetaData;
        super._mint(owner, lastTokenId, 0, "");
        return true;
    }

    function mint(
        address user,
        uint256 amount,
        address asset
    ) public override returns(bool) {
        uint256 tokenId = depositMetaData[asset].TOKEN_ID;
        require(tokenId<=lastTokenId,"Token Id is not present");
        IERC20(asset).transferFrom(user, depositMetaData[asset].RESERVE_TREASURY_ADDRESS, amount);
        emit Mint(user,amount,tokenId);
        return true;
    }

    function burn(
        address user,
        address receiverOfUnderlying,
        uint256 amount,
        address asset

    ) public override returns(bool) {
        uint256 tokenId = depositMetaData[asset].TOKEN_ID;
        require(tokenId<=lastTokenId,"Token Id is not present");
        super._burn(user, tokenId, amount);

        IERC20(asset).transferFrom(depositMetaData[asset].RESERVE_TREASURY_ADDRESS, user, amount);
        emit Burn(user,receiverOfUnderlying,amount,tokenId);
        return true;
    }

    function decimals() public pure returns (uint8){
        return 18;
    }



}
