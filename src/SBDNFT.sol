// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error SoudBounded();

contract SBDNFT is ERC721, ERC721Burnable, Ownable {
    enum Level {
        // TODO: clarify the levels by changing the names
        level1,
        level2,
        level3,
        level4,
        level5,
        level6
    }

    uint256 private _tokenIdCounter;

    string[6] dnftUri = [
        "https://gold-cool-goat-213.mypinata.cloud/ipfs/QmfFbvLH37DebBqmVBm7V8ecfzgjFPnPeHRYiYk1PNoW84/1level.png",
        "https://gold-cool-goat-213.mypinata.cloud/ipfs/QmfFbvLH37DebBqmVBm7V8ecfzgjFPnPeHRYiYk1PNoW84/2level.png",
        "https://gold-cool-goat-213.mypinata.cloud/ipfs/QmfFbvLH37DebBqmVBm7V8ecfzgjFPnPeHRYiYk1PNoW84/3level.png",
        "https://gold-cool-goat-213.mypinata.cloud/ipfs/QmfFbvLH37DebBqmVBm7V8ecfzgjFPnPeHRYiYk1PNoW84/4level.png",
        "https://gold-cool-goat-213.mypinata.cloud/ipfs/QmfFbvLH37DebBqmVBm7V8ecfzgjFPnPeHRYiYk1PNoW84/5level.png",
        "https://gold-cool-goat-213.mypinata.cloud/ipfs/QmfFbvLH37DebBqmVBm7V8ecfzgjFPnPeHRYiYk1PNoW84/6level.png"
    ];

    mapping(uint256 => string) private _tokenURIs;

    constructor(
        address owner
    ) ERC721("SoulBoundDynamicNFT", "SBDNFT") Ownable(owner) {}

    function tokenURI(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        _requireOwned(tokenId);
        return _tokenURIs[tokenId];
    }

    function safeMint(address to) public onlyOwner returns (uint256) {
        _tokenIdCounter += 1;
        uint256 _tokenId = _tokenIdCounter;
        _safeMint(to, _tokenId);
        _setTokenURI(_tokenId, Level.level1);
        return _tokenId;
    }

    function upgrade(uint256 tokenId) public {
        // TODO: implement upgrade function
    }

    function _setTokenURI(uint256 tokenId, Level level) internal virtual {
        _requireOwned(tokenId);
        _tokenURIs[tokenId] = dnftUri[uint256(level)];
    }

    function _getLevel(uint256 tokenId) internal view returns (uint256) {
        // TODO: implement get level function
    }

    /* 
        disable transfer and approve functions by overriding them with revert
        to make sure that the token is not transferable (soulbound)
    */
    function transferFrom(
        address from,
        address,
        uint256
    ) public virtual override {
        // _checkOnERC721Received(from, to, tokenId, data); is unreachable in safeTransferFrom function
        // so we need to check and pass the control flow to _checkOnERC721Received manually
        if (from != address(0)) {
            revert SoudBounded();
        }
    }

    function approve(address, uint256) public virtual override {
        revert SoudBounded();
    }

    function setApprovalForAll(address, bool) public virtual override {
        revert SoudBounded();
    }
}
