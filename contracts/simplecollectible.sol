//SPDX-Identifier-License:MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SimpleCollectible is ERC721 {
    uint public tokenCounter;

    constructor () ERC721 ("Relic", "REL"){
        tokenCounter = 0;
    }

    function createCollectible(string memory _tokenURI) public returns (uint){
        uint newTokenId = tokenCounter;
        _safeMint(msg.sender, newTokenId);
        _setTokenURI(newTokenId, _tokenURI);
        tokenCounter += tokenCounter;
        return newTokenId;
    }
}