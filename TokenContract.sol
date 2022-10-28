// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TokenContract is ERC721 {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    uint256 private MAX_SUPPLY;
    address private _contractAddress;

    constructor(uint256 _maxSupply) ERC721("Anhihi Token", "Anhihi") {
        MAX_SUPPLY = _maxSupply;
    }

    function createToken(string memory tokenURI) public returns (uint256) {
        require(_tokenIdCounter.current() <= MAX_SUPPLY, "I'm sorry number of token reached the cap");
        _tokenIdCounter.increment();
        uint256 newItemId = _tokenIdCounter.current();
        _mint(msg.sender, newItemId); //mint the token
        _setTokenURI(newItemId,  ); //generate the URI
        setApprovalForAll(contractAddress, true); //grant transaction permission to marketplace
        return newItemId;
    }

}