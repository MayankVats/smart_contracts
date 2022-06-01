// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

contract Locker {
    mapping(address => uint256) public balanceOf;

    event Deposit(address indexed from, uint256 amount);
    event Withdraw(address indexed by, uint256 amount);

    function deposit() external payable {
        require(msg.value > 0, "no amount deposited");
        balanceOf[msg.sender] = msg.value;

        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 amount) external {
        require(amount != balanceOf[msg.sender], "withdrawing whole amount");
        require(
            amount < balanceOf[msg.sender],
            "withdraw amount exceeds deposited"
        );

        balanceOf[msg.sender] = balanceOf[msg.sender] - amount;

        emit Withdraw(msg.sender, amount);
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
