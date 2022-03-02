// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**

- We want to call function1 and function2, we can call them one by one.
- Problem: block.timestamp maybe different.

- Solution: we can aggregate these two function call into a single query, by writing a contract MultiCall

*/

contract TestMultiCall {
    function func1() public view returns (uint256, uint256) {
        return (1, block.timestamp);
    }

    function func2() public view returns (uint256, uint256) {
        return (2, block.timestamp);
    }

    function getData1() external pure returns (bytes memory) {
        // abi.encodeWithSignature("func1()");
        return abi.encodeWithSelector(this.func1.selector);
    }

    function getData2() external pure returns (bytes memory) {
        // abi.encodeWithSignature("func2 ()");
        return abi.encodeWithSelector(this.func2.selector);
    }
}

contract MultiCall {
    function multiCall(address[] calldata targets, bytes[] calldata data)
        external
        view
        returns (bytes[] memory)
    {
        require(
            targets.length == data.length,
            "Target and Data length mismatch"
        );

        bytes[] memory results = new bytes[](data.length);

        for (uint256 i; i < targets.length; i++) {
            (bool success, bytes memory result) = targets[i].staticcall(
                data[i]
            );
            require(success, "failed");

            results[i] = result;
        }

        return results;
    }
}

// Since the function is view, we are making a static call.
// If you want to make a transaction, use call.
