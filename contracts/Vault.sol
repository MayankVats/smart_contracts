// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20Permit.sol";

contract Vault {
    ERC20Permit public Token;

    constructor(address _token) {
        Token = ERC20Permit(_token);
    }

    function deposit(uint256 amount) external {
        Token.transferFrom(msg.sender, address(this), amount);
    }

    /**
    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    )
    */
    function depositWithPermit(
        uint256 amount,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        Token.permit(msg.sender, address(this), amount, deadline, v, r, s);
        Token.transferFrom(msg.sender, address(this), amount);
    }
}
