// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**

  selfdestruct:
  - It is function which can delete the contract from the blockchain.
  - It also forces the contract to send ether to any address, even to the contract that does not support payable.

*/

contract Kill {
    constructor() payable {}

    function kill() external {
        selfdestruct(payable(msg.sender));
    }

    function testCall() external pure returns (uint256) {
        return 123;
    }
}
