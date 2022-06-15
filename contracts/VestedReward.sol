// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract VestedReward {
    struct Reward {
        uint256 amountPerMonth;
        uint256 months;
        uint256 amountDistributed;
        uint256 startTime;
        IERC20 token;
    }
    mapping(address => Reward) public rewards;

    function createAllocation(
        address _recipient,
        uint256 _amountPerMonth,
        uint256 _months,
        address _token
    ) external {
        IERC20(_token).transferFrom(
            msg.sender,
            address(this),
            _amountPerMonth * _months
        );

        rewards[_recipient] = Reward(
            _amountPerMonth,
            _months,
            0,
            block.timestamp,
            IERC20(_token)
        );
    }

    function distributeRewards(address recipient) external {
        Reward storage reward = rewards[recipient];
        require(reward.startTime > 0, "Reward non existent");

        uint256 amountVested = ((block.timestamp - reward.startTime) /
            30 days) * reward.amountPerMonth;

        uint256 amountToDistribute = amountVested - reward.amountDistributed;
        require(amountToDistribute > 0, "No rewards");

        reward.amountDistributed += amountToDistribute;
        reward.token.transfer(recipient, amountToDistribute);
    }
}
