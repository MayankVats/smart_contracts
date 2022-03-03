// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract EnglishAuction {
    IERC721 public immutable nft;
    uint256 public immutable nftId;

    address payable public immutable seller;
    // can store upto 100 years from now
    uint32 public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint256 public highestBid;
    mapping(address => uint256) bids;

    event Start();
    event Bid(address indexed _bidder, uint256 _bid);
    event Withdraw(address indexed _bidder, uint256 _val);
    event End(address _highestBidder, uint256 _amount);

    constructor(
        address _nft,
        uint256 _nftId,
        uint256 _startingBid
    ) {
        nft = IERC721(_nft);
        nftId = _nftId;
        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    function start() external {
        require(msg.sender == seller, "not seller");
        require(!started, "started");

        started = true;
        endAt = uint32(block.timestamp + 60);

        nft.transferFrom(seller, address(this), nftId);

        emit Start();
    }

    function bid() external payable {
        require(started, "started");
        require(block.timestamp < endAt, "ended");
        require(msg.value > highestBid, "not highest bid");

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBid = msg.value;
        highestBidder = msg.sender;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() external {
        uint256 val = bids[msg.sender];

        // we are resetting the state variable first
        // to prevent reentrancy attack
        bids[msg.sender] = 0;

        payable(msg.sender).transfer(val);

        emit Withdraw(msg.sender, val);
    }

    function end() external {
        require(started, "not started");
        require(!ended, "not ended");
        require(block.timestamp >= endAt, "not ended");

        ended = true;
        if (highestBidder != address(0)) {
            nft.transferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.transferFrom(address(this), seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }
}
