// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";

contract Testament {
    
    using Address for address payable;
    
    address private _owner;
    address private _doctor;
    uint256 private _deathDate;
    bool private _isDead;
    uint256 private _count;
    mapping(address => uint256) private _balances;
    
    constructor (address owner_, address doctor_) {
        _owner = owner_;
        _doctor = doctor_;
    }
    
    event Died(uint256 deathDate, bool isDead, address owner, address doctor);
    
    modifier isOwner {
        require(msg.sender == _owner, "Sorry, you are not allowed to execute this action.");
        require(isDead == false, "You are supposed to be dead...");
        _;
    }
    
    modifier isDoctor {
        require(msg.sender == _doctor, "Sorry, you are not the appointed person for this action.");
        require(_count == 0, "Already said to be dead!");
        _;
    }
    
    modifier isDead {
        require(_isDead = true, "Sorry, not dead yet!");
    }
    
    function pickDoctor(address doctor_) isOwner public {
        _doctor = doctor_;
    }
    
    function bequeath(address account, uint256 amount) isOwner public payable {
        _balances[account] += amount;
    }
    
    function setDeath() isDoctor public {
        _deathDate = block.timestamp;
        _isDead = true;
        emit Died(_deathDate, _isDead, _owner, _doctor);
        _count += 1;
    }
    
    function getBalance() public view returns (uint256) {
        return _balances[msg.sender];
    }
    
    function withdrawFunds() isDead public payable {
        uint256 amount = _balances[msg.sender];
        _balances[msg.sender] = 0;
        payable(msg.sender).sendValue(amount);
    }
}