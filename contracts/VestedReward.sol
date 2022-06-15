// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VestedReward {
    IERC20 public token;

    struct Reward {
        uint256 amountPerMonth;
        uint256 months;
        uint256 amountDistributed;
        uint256 startTime;
    }
    mapping(address => Reward) public rewards;

    function createAllocation(
        address recipient,
        uint256 amountPerMonth,
        uint256 months
    ) external {
        token.transferFrom(msg.sender, address(this), amountPerMonth * months);

        rewards[recipient] = Reward(amountPerMonth, months, 0, block.timestamp);
    }

    function distributeRewards(address recipient) external {
        Reward storage reward = rewards[recipient];
        require(reward.startTime > 0, "Reward non existent");

        uint256 amountVested = ((block.timestamp - reward.startTime) /
            30 days) * reward.amountPerMonth;

        uint256 amountToDistribute = amountVested - reward.amountDistributed;
        require(amountToDistribute > 0, "No rewards");

        reward.amountDistributed += amountToDistribute;
        token.transfer(recipient, amountToDistribute);
    }
}
