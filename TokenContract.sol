// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract TokenContract is ERC721URIStorage, ReentrancyGuard {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    uint256 private MAX_SUPPLY;
    address private _creator;

    constructor(uint256 _maxSupply) ERC721("Anhihi Token", "ANH") {
        _creator = msg.sender;
        MAX_SUPPLY = _maxSupply;
    }

    function setMaxSupply(uint256 _maxSupply) external {
        require(msg.sender == _creator, "Your are not creator!");
        MAX_SUPPLY = _maxSupply;
    }

    function getTotalTokenNumber() external view returns (uint256 _totalTokens) {
        _totalTokens = _tokenIdCounter.current();
    }

    function createToken(string memory tokenURI) public returns (uint256) {
        require(_tokenIdCounter.current() < MAX_SUPPLY, "I'm sorry number of token reached the cap");
        _tokenIdCounter.increment();
        uint256 newItemId = _tokenIdCounter.current();
        _mint(msg.sender, newItemId); //mint the token
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
