// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
  Reentrancy:
  - Contract A calls Contract B.
  - Contract B calls back into Contract A, while A is executing.

  Example:
  ========

  Contract A:                               Contract B:
  [                                         [
    withdraw() {                               fallback() {
      check balance > 0                            A.withdraw()
      send Ether                               }
      balance = 0                              attack() {
    }                                              A.withdraw()
  ]                                            }
                                            ]

  Preventive Measures:
  ====================
  - Update state variables before making any external calls to the contract.
  - Reentrancy modifier
*/

contract EtherStore {
    mapping(address => uint256) balanceOf;

    bool internal locked = false;

    modifier nonReentrant() {
        require(!locked, "No re-entrancy");
        locked = true;
        _;
        locked = false;
    }

    function deposit() external payable {
        balanceOf[msg.sender] += msg.value;
    }

    function withdraw(uint256 _amount) external nonReentrant {
        require(_amount <= balanceOf[msg.sender], "insufficient funds");

        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "failed to withdraw");

        // Move the line below up above the external call
        balanceOf[msg.sender] -= _amount;
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}

contract Attack {
    EtherStore public etherStore;

    fallback() external {
        if (address(etherStore).balance >= 1 ether) {
            etherStore.withdraw(1 ether);
        }
    }

    function attack() external payable {
        require(msg.value >= 1 ether);

        etherStore.deposit{value: 1 ether}();

        etherStore.withdraw(1 ether);
    }
}
