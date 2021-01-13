// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.12;

contract randomNum {
    
    uint nonce;
    
    function getNum(uint range) external returns(uint) {
        uint num = _generateRandom(range);
        return num;
    }
    
    function _generateRandom(uint range) internal returns(uint) {
        uint num;
        num = uint(keccak256(abi.encodePacked(
            nonce,
            now, 
            block.difficulty, 
            msg.sender
        )));
        nonce++;
        return num % range;
    }
    
}
