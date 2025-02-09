pragma solidity ^0.8.0;

/**
 * @title MyToken
 * @author [Your Name]
 * @license MIT
 */
contract MyToken {
    string public name = "My Token";
    string public symbol = "MYT";
    uint public totalSupply = 1000000 * (10 ** 18);
    uint public decimals = 18;

    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;

    address public owner;
    bool public paused = false;

    constructor() {
        owner = msg.sender;
        balanceOf[owner] = totalSupply;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    modifier whenNotPaused() {
        require(!paused, "Contract is paused");
        _;
    }

    function transfer(address recipient, uint amount) public whenNotPaused returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint amount) public whenNotPaused returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint amount) public whenNotPaused returns (bool) {
        require(balanceOf[sender] >= amount, "Insufficient balance");
        require(allowance[sender][msg.sender] >= amount, "Insufficient allowance");
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function pause() public onlyOwner {
        paused = true;
    }

    function unpause() public onlyOwner {
        paused = false;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}
