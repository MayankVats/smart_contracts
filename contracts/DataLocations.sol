// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**

  - When we use a dynamic type as a variable we need to declare its data location
  - storage, memory and calldata 
  - calldata is like memory, except you can use it only for function inputs.
  - calldata saves gas if we use it as function inputs. 

*/

contract DataLocations {
    struct Person {
        string name;
        uint256 age;
    }

    mapping(address => Person) public users;

    function example(uint256[] memory y, string memory s)
        external
        returns (Person memory)
    {
        users[msg.sender] = Person({name: "Martin", age: 21});

        // tells solidity that "user" should point back to storage
        // we use this when we want to modify the struct
        Person storage user = users[msg.sender];

        // If we don't want to modify it over storage, and only read it then we can use memory.

        // - use storage when you want to modify the data and memory when you want to read the data.
    }
}
