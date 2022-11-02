// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7 <0.9.0;

import "./node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "./node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Marketplace is ReentrancyGuard {
    Counters.Counter private _itemId;
    Counters.Counter private _itemsSold;

    address payable owner;
    uint256 public mintingCost = 0.0001 ether;

    constructor(uint256 firstMintingCost) {
        owner = payable(msg.sender);
        mintingCost = firstMintingCost;
    }

    enum ListingStatus {
        Active,
        Sold,
        Cancelled
    }

    struct _NftItem {
        ListingStatus status;
        address nftContract;
        address payable owner;
        address payable creator;
        uint256 token;
        uint256 price;
    }
 
    event MakeNftItem(
        address nftContract,
        address owner,
        address creator,
        uint256 token,
        uint256 price
    );

    event CancelSell(uint256 token, address owner);

    event Sold(
        address nftContract,
        address owner,
        address creator,
        uint256 token,
        uint256 price
    );

    mapping(uint => _NftItem) public Items;


}
