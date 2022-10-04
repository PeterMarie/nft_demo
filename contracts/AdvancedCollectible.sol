// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Lottery is ERC721, VRFConsumerBaseV2, Ownable {

    VRFCoordinatorV2Interface COORDINATOR;
    uint64 s_subscriptionId = 396;
    bytes32 public keyHash;
    address VRFCoordinator;
    uint16 requestConfirmations = 3;
    uint32 callbackGasLimit = 1000000;
    uint32 numWords = 1;
    uint public s_requestId;
    uint256[] public s_randomWords;

    uint public tokenCounter;
    string baseURI;

    enum Breed {
        PUG,
        SHIBA_INU,
        ST_BERNARD
    }

    mapping(uint=>address) requestidtosender;
    event requestedRandomWords(uint indexed requestId, address requester);

    mapping(uint=>Breed) tokenidtobreed;
    mapping(uint=>string) tokenidtotokenuri;
    event requestedCollectible(uint indexed tokenId, Breed breed);

    constructor(
            uint64 subscriptionId,
            address _VRFCoordinator,
            bytes32 _keyhash
        ) VRFConsumerBaseV2(_VRFCoordinator)
        ERC721 ("TestRelic", "TREL") {
            tokenCounter = 0;
            VRFCoordinator = _VRFCoordinator;
            COORDINATOR = VRFCoordinatorV2Interface(_VRFCoordinator);
            s_subscriptionId = subscriptionId;
            keyHash = _keyhash;
    }

    function createCollectible() public {
        requestRandomWords();
    }
    
    // Assumes the subscription is funded sufficiently.
    function requestRandomWords() public onlyOwner {
        // Will revert if subscription is not set and funded.
        s_requestId = COORDINATOR.requestRandomWords(
        keyHash,
        s_subscriptionId,
        requestConfirmations,
        callbackGasLimit,
        numWords
        );
        requestidtosender[s_requestId] = msg.sender;
        emit requestedRandomWords(s_requestId, msg.sender);
    }
    
    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        uint new_token_id = tokenCounter;
        address owner = requestidtosender[requestId];
        _safeMint(owner, new_token_id);
        Breed breed = Breed(randomWords[0] % 3);
        tokenidtobreed[new_token_id] = breed;
        tokenCounter++;
        emit requestedCollectible(new_token_id, breed);
    }

    function setTokenURI(uint _tokenId, string memory _tokenURI) public {
        require(_isApprovedOrOwner(msg.sender, _tokenId), "You Don't Own this NFT!");
        tokenidtotokenuri[_tokenId] = _tokenURI;
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(_exists(_tokenId), "ERC721Metadata: URI query for nonexistent token");
        return tokenidtotokenuri[_tokenId];
    }


}