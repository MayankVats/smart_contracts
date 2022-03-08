// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
  "Fallback" function is a special function that is executed when:
  - the function that is called does not exist in the contract.
  - ETH is directly sent to the contract.
*/

/**
  Difference Between Fallback and Receive
  =======================================

  When ether is sent to this contract check:
    - Is msg.data empty ?
      - No: then call fallback()
      - Yes: then call receive() if it exist, otherwise call fallback()
 */

contract Fallback {
    event Log(string func, address sender, uint256 value, bytes data);

    // This function gets executed when a function that does not exist is called.
    // Enables Smart Contract to receive ether.
    fallback() external payable {
        emit Log("fallback", msg.sender, msg.value, msg.data);
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }
}
