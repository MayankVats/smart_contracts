// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyNft is ERC721 {
    using Counters for Counters.Counter;

    address public NftShop;
    address public shopOwner;

    Counters.Counter public nftCounter;

    constructor(string memory _name, string memory _symbol)
        ERC721(_name, _symbol)
    {
        shopOwner = msg.sender;
    }

    modifier onlyShopOwner() {
        require(msg.sender == shopOwner, "not the shop owner");
        _;
    }

    modifier onlyShop() {
        require(msg.sender == NftShop, "minter is not shop");
        _;
    }

    function mint() external onlyShop {
        _mint(NftShop, nftCounter.current());
        nftCounter.increment();
    }

    function updateNftShopAddress(address _shop) external onlyShopOwner {
        require(_shop != address(0), "zero address set");
        NftShop = _shop;
    }

    function exists(uint256 _tokenId) external view returns (bool) {
        return _exists(_tokenId);
    }
}
