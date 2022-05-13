// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract RapidIceCreams is Ownable {
    enum Flavours {
        CHOCOLATE,
        VANILLA
    }

    event IceCreamCreated(
        Flavours _flavour,
        uint256 _priceInEther,
        uint256 _amountInStock
    );
    event IceCreamBought(Flavours _flavour, address _buyer, uint256 _amount);

    bool public shopOpened;

    struct IceCream {
        Flavours flavour;
        uint256 priceInEther;
        uint256 amountInStock;
    }

    mapping(Flavours => IceCream) public iceCreamInfo;

    mapping(address => uint256) public buyerInfo;

    constructor() {
        iceCreamInfo[Flavours.CHOCOLATE] = IceCream({
            flavour: Flavours.CHOCOLATE,
            priceInEther: 0.01 ether,
            amountInStock: 100
        });
        emit IceCreamCreated(Flavours.CHOCOLATE, 0.01 ether, 100);

        iceCreamInfo[Flavours.VANILLA] = IceCream({
            flavour: Flavours.VANILLA,
            priceInEther: 0.005 ether,
            amountInStock: 100
        });
        emit IceCreamCreated(Flavours.VANILLA, 0.005 ether, 100);

        shopOpened = false;
    }

    function buyIceCream(Flavours _flavour, uint256 _amount) external payable {
        require(shopOpened, "shop is not opened");
        require(
            iceCreamInfo[_flavour].amountInStock > _amount,
            "not enough amount in stock"
        );
        require(
            iceCreamInfo[_flavour].priceInEther * _amount == msg.value,
            "not enough fund recieved"
        );

        buyerInfo[msg.sender] += 1;
        iceCreamInfo[_flavour].amountInStock -= _amount;

        emit IceCreamBought(_flavour, msg.sender, _amount);
    }

    function openShop() external onlyOwner {
        require(!shopOpened, "shop already opened");
        shopOpened = true;
    }

    function closeShop() external onlyOwner {
        require(shopOpened, "shop already closed");
        shopOpened = false;
    }

    function makeIceCreams(Flavours _flavour, uint256 _amount)
        external
        onlyOwner
    {
        iceCreamInfo[_flavour].amountInStock += _amount;

        emit IceCreamCreated(Flavours.CHOCOLATE, 0.01 ether, _amount);
    }

    function withdrawFunds() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
