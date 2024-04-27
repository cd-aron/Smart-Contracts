// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT_Contract is ERC721, Ownable {
    // Keeps track of the token ID when NFT is created
    uint256 private _nextTokenId;

    // Mapping to store IPFS hash for each token
    mapping(uint256 => string) private _tokenIPFSHashes;

    // Mapping to store URL for each token
    mapping(uint256 => string) private _tokenURLs;

    constructor(address initialOwner)
        ERC721("Certificate", "Certificate")
        Ownable(initialOwner)
    {}

    function CreateNFT(address owner, string memory content_id, string memory content_url) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _safeMint(owner , tokenId);
        _setTokenURI(tokenId, content_id);
        _setTokenURL(tokenId, content_url);

        // Emit an event or store URL in contract storage
        // Here, I'm just emitting an event
        emit CertificateCreated(tokenId, content_id, content_url);
    }

    function _setTokenURI(uint256 tokenId, string memory content_id) internal {
        _tokenIPFSHashes[tokenId] = content_id;
    }

    function _setTokenURL(uint256 tokenId, string memory content_url) internal {
        _tokenURLs[tokenId] = content_url;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return _tokenIPFSHashes[tokenId];
    }

    function getTokenURL(uint256 tokenId) public view returns (string memory) {
        return _tokenURLs[tokenId];
    }

    // Event to emit when a certificate is created
    event CertificateCreated(uint256 indexed tokenId, string contend_id, string content_url);

    // Override the ownerOf function
    function ownerOf(uint256 tokenId) public view override(ERC721) returns (address) {
        return ERC721.ownerOf(tokenId);
    }

  function verifyNFT(bytes32 transactionHash, uint256 tokenId, address owner) public view returns (bool) {
        // Retrieve the IPFS hash and owner of the NFT using the provided tokenId
        string memory ipfsHash = _tokenIPFSHashes[tokenId];
        address tokenOwner = ownerOf(tokenId);
        
        // Check if the provided transaction hash corresponds to the creation of the NFT,
        // if the provided token ID matches the NFT's token ID,
        // and if the provided owner matches the owner of the NFT
        return transactionHash == keccak256(abi.encodePacked(ipfsHash)) && tokenId != 0 && owner == tokenOwner;
    }





    
}

