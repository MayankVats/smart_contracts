// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "./NFT.sol";

contract NftShop {
    MyNft public nftCollection;

    address public shopOwner;
    uint256 public priceOfNft = 0.01 ether;

    constructor(address _nftCollection) {
        require(_nftCollection != address(0), "zero address set");
        nftCollection = MyNft(_nftCollection);
        shopOwner = msg.sender;
    }

    /// @notice modifier to check the caller is the owner
    modifier onlyShopOwner() {
        require(msg.sender == shopOwner, "not the shop owner");
        _;
    }

    /// @notice function to mint "_count" number of NFTs to this shop, can be called by owner only
    /// @param _count number of NFTs to mint
    function mintNfts(uint256 _count) external onlyShopOwner {
        for (uint256 i = 0; i < _count; i++) {
            nftCollection.mint();
        }
    }

    /// @notice function to buy NFT
    /// @notice should send value equal to or greater than the price of NFT
    /// @param _nftId the ID of the NFT
    function buyNft(uint256 _nftId) external payable {
        require(nftCollection.exists(_nftId), "nft does not exist");
        require(
            nftCollection.ownerOf(_nftId) == address(this),
            "shop does not have this nft"
        );
        require(msg.value >= priceOfNft, "insufficient payment");

        uint256 refundAmount = msg.value - priceOfNft;
        if (refundAmount > 0) {
            payable(msg.sender).transfer(refundAmount);
        }

        nftCollection.transferFrom(address(this), msg.sender, _nftId);
    }

    /// @notice function to sell NFT
    /// @param _nftId the ID of the NFT
    function sellNft(uint256 _nftId) external payable {
        require(nftCollection.exists(_nftId), "nft does not exist");
        nftCollection.transferFrom(msg.sender, address(this), _nftId);
        payable(msg.sender).transfer(priceOfNft);
    }
}
