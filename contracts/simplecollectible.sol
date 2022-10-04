//SPDX-License-Identifier:MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract SimpleCollectible is ERC721Enumerable {
    uint public tokenCounter;
    string baseURI;

    constructor (string memory _tokenBaseURI) ERC721 ("TestRelic", "TREL"){
        _setBaseURI(_tokenBaseURI);
        tokenCounter = 0;
    }

    function _setBaseURI(string memory _newBaseURI) public {
        baseURI = _newBaseURI;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory contractBaseURI = _baseURI();
        return bytes(contractBaseURI).length > 0 ? string(abi.encodePacked(contractBaseURI)) : "";
    }

    function createCollectible() public returns (uint){
        uint newTokenId = tokenCounter;
        _safeMint(msg.sender, newTokenId);
        tokenCounter = tokenCounter + 1;
        return newTokenId;
    }

}