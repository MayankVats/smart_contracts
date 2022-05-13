// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract RapidIceCreams is AccessControl {
    bytes32 public constant GUARD_ROLE = keccak256("GUARD_ROLE");
    bytes32 public constant MAKER_ROLE = keccak256("MAKER_ROLE");

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

        _setupRole(GUARD_ROLE, 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
        _setupRole(MAKER_ROLE, 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db);
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
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

    function openShop() external onlyRole(GUARD_ROLE) {
        require(!shopOpened, "shop already opened");
        shopOpened = true;
    }

    function closeShop() external onlyRole(GUARD_ROLE) {
        require(shopOpened, "shop already closed");
        shopOpened = false;
    }

    function makeIceCreams(Flavours _flavour, uint256 _amount)
        external
        onlyRole(MAKER_ROLE)
    {
        iceCreamInfo[_flavour].amountInStock += _amount;

        emit IceCreamCreated(Flavours.CHOCOLATE, 0.01 ether, _amount);
    }

    function withdrawFunds(address _recipient)
        external
        onlyRole(DEFAULT_ADMIN_ROLE)
    {
        payable(_recipient).transfer(address(this).balance);
    }
}
