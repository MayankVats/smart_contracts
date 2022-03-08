// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint256 amount);
    event Submit(uint256 indexed txId);
    event Approve(address indexed owner, uint256 indexed txId);
    event Revoke(address indexed owner, uint256 indexed txId);
    event Execute(uint256 indexed txId);

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
    }

    address[] public owners;
    mapping(address => bool) public isOwner;

    uint256 public approvalsRequired;

    Transaction[] public transactions;
    mapping(uint256 => mapping(address => bool)) isApprovedBy;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }

    modifier txExists(uint256 _txId) {
        require(_txId < transactions.length, "transaction not found");
        _;
    }

    modifier notApproved(uint256 _txId) {
        require(!isApprovedBy[_txId][msg.sender], "already approved");
        _;
    }

    modifier notExecuted(uint256 _txId) {
        require(!transactions[_txId].executed, "transaction executed");
        _;
    }

    constructor(address[] memory _owners, uint256 _approvalsRequired) {
        require(_owners.length > 0, "owners required");
        require(
            _approvalsRequired > 0 && _owners.length >= _approvalsRequired,
            "invalid number of approvals required"
        );

        for (uint256 i; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "invalid address");
            require(!isOwner[owner], "already an owner");

            isOwner[owner] = true;
            owners.push(owner);
        }

        approvalsRequired = _approvalsRequired;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    // we are using calldata here
    // since this function is external
    // and instead of using memory, calldata is cheaper on gas.
    function submitTransaction(
        address _to,
        uint256 _value,
        bytes calldata _data
    ) external onlyOwner {
        transactions.push(
            Transaction({to: _to, value: _value, data: _data, executed: false})
        );

        emit Submit(transactions.length - 1);
    }

    function approveTransaction(uint256 _txId)
        external
        onlyOwner
        txExists(_txId)
        notApproved(_txId)
        notExecuted(_txId)
    {
        isApprovedBy[_txId][msg.sender] = true;
        emit Approve(msg.sender, _txId);
    }

    function executeTransaction(uint256 _txId)
        external
        onlyOwner
        txExists(_txId)
        notExecuted(_txId)
    {
        require(
            _getApprovalCount(_txId) >= approvalsRequired,
            "not enough approvals"
        );
        Transaction storage transaction = transactions[_txId];

        transaction.executed = true;

        (bool success, ) = transaction.to.call{value: transaction.value}(
            transaction.data
        );

        require(success, "tx failed");

        emit Execute(_txId);
    }

    function revokeTransaction(uint256 _txId)
        external
        onlyOwner
        txExists(_txId)
        notExecuted(_txId)
    {
        require(isApprovedBy[_txId][msg.sender], "not approved");

        isApprovedBy[_txId][msg.sender] = false;

        emit Revoke(msg.sender, _txId);
    }

    function _getApprovalCount(uint256 _txId)
        internal
        view
        returns (uint256 count)
    {
        for (uint256 i; i < owners.length; i++) {
            address owner = owners[i];

            if (isApprovedBy[_txId][owner]) {
                count += 1;
            }
        }
    }
}
