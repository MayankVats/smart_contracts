// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
  Library allows you to seperate and reuse code, it also allows you to enhance data types.
*/

library Math {
    // Cannot declare state variables inside here.

    // If you make this function public, then you have to deploy the library seperately from the contract TestLibrary.
    function max(uint256 x, uint256 y) internal pure returns (uint256) {
        return x >= y ? x : y;
    }
}

library ArrayLib {
    function find(uint256[] storage arr, uint256 x)
        internal
        view
        returns (uint256)
    {
        for (uint256 i; i < arr.length; i++) {
            if (arr[i] == x) {
                return i;
            }
        }

        revert("not found");
    }
}

contract TestLibrary {
    function testMax(uint256 x, uint256 y) external pure returns (uint256) {
        return Math.max(x, y);
    }
}

contract TestLibrary2 {
    using ArrayLib for uint256[];
    uint256[] public arr = [1, 2, 3];

    function testFind() external view returns (uint256 i) {
        // return ArrayLib.find(arr, 2);
        return arr.find(2);
    }
}
