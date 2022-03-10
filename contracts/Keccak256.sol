// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
  Keccak256 is widely used cryptographic hash function. Usecases are as follows:
  - Sign a signature
  - Unique Id 

  Keccak256 accepts bytes as inputs and gives bytes32 as an output.
*/

contract Keccak256 {
    function Hash(
        string memory text,
        uint256 num,
        address addr
    ) external pure returns (bytes32) {
        return keccak256(abi.encodePacked(text, num, addr));
    }

    function encode(string memory text0, string memory text1)
        external
        pure
        returns (bytes memory)
    {
        return abi.encode(text0, text1);
    }

    function encodePacked(string memory text0, string memory text1)
        external
        pure
        returns (bytes memory)
    {
        return abi.encodePacked(text0, text1);
    }

    function collision(string memory text0, string memory text1)
        external
        pure
        returns (bytes32)
    {
        return keccak256(abi.encodePacked(text0, text1));
    }

    // Difference between abi.encode and abi.encodePacked
    // - They both encodes the data into bytes, but encodePacked encodes into bytes but also compresses it.
    // - The output of the encodePacked will be smaller.

    // There may be a situation where we may create a hash collision (output of the hash function will be same even when inputs are different).

    // Hash Collision example
    // abi.encodePacked("AAAA", "BBB") => 0x41414141424242
    // abi.encodePacked("AAA", "ABBB") => 0x41414141424242

    // Solution: rearrange the dynamic inputs.
}
