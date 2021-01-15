pragma solidity ^0.6.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
    address public owner;
    string public name = "Dapp Token Farm";
    DappToken public dappToken;
    DaiToken public daiToken;

    address[] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    function stakeTokens(uint _amount) public {
        // _amount cannot be 0
        require(_amount > 0, 'amount cannot be 0');

        // Transfer Mock DAI Tokens to this contract for staking
        daiToken.transferFrom(msg.sender, address(this), _amount);

        // Update Staking balance
        stakingBalance[msg.sender] += _amount;

        // Add users to stakers array iff they haven't staked
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        // Update staking status
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    function issueTokens() public {
        // Only owners can call this function
        require(msg.sender == owner, 'caller must be the owner');

        // Issue all tokens to stakers
        for(uint i=0; i<stakers.length; i++) {
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if(balance > 0) {
                dappToken.transfer(recipient, balance);
            }
        }
    }

    function unstakeTokens() public {
        // Fetch staking balance of investor
        uint balance = stakingBalance[msg.sender];

        // Balance should not be 0
        require(balance > 0, 'staking balance cannot be 0');
    
        // Transfer dai token back to investor
        daiToken.transfer(msg.sender, balance);

        // reset the staking balance
        stakingBalance[msg.sender] = 0;

        // update staking status
        isStaking[msg.sender] = false;
    }
}
