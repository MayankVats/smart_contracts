// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;

contract TokenFactory {
    
    mapping(string => Token) public tokens;
    
    function createToken(string memory _name, string memory _symbol, uint8 _decimals) external {
        Token _token = new Token(_name, _symbol, _decimals, msg.sender);
        tokens[_name] = _token;
    }
    
}


contract Token {
    string  public name;
    string  public symbol;
    uint256 public totalSupply = 10000000000000000000000000; // 10 million tokens
    uint8   public decimals;
    
    address public owner;

    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
    
    event Creation(
        address _owner,
        uint256 _bal
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol, uint8 _decimals, address _owner) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        owner = _owner;
        balanceOf[owner] = totalSupply;
        emit Creation(owner, totalSupply);
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from]);
        require(_value <= allowance[_from][msg.sender]);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}
