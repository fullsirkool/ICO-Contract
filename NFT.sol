// SPDX-License-Identifier: MIT
pragma solidity >=0.8.7 <0.9.0;

import "./node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./node_modules/@openzeppelin/contracts/utils/Counters.sol";
import "./node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721URIStorage, ReentrancyGuard, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    uint256 private MAX_SUPPLY;

    constructor(uint256 _maxSupply) ERC721("Anhihi Token", "ANH") {
        MAX_SUPPLY = _maxSupply;
    }

    function setMaxSupply(uint256 _maxSupply) external onlyOwner {
        MAX_SUPPLY = _maxSupply;
    }

    function getTotalTokenNumber() external view returns (uint256 _totalTokens) {
        _totalTokens = _tokenIdCounter.current();
    }

    function createToken(string memory tokenURI) public returns (uint256) {
        require(_tokenIdCounter.current() < MAX_SUPPLY, "I'm sorry number of token reached the cap");
        _tokenIdCounter.increment();
        uint256 newItemId = _tokenIdCounter.current();
        _safeMint(msg.sender, newItemId); //mint the token
        _setTokenURI(newItemId,  tokenURI); //generate the URI
        return newItemId;
    }

    function transferToken(address to, uint256 tokenId) external {
        require(msg.sender == ownerOf(tokenId), "Sorry, You're not owner of this token!");
        safeTransferFrom(msg.sender, to, tokenId);
    }

    function burnToken(uint256 tokenId) external {
        require(msg.sender == ownerOf(tokenId), "Sorry, You're not owner of this token!");
        _burn(tokenId);
    }

}
