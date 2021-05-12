// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";

contract Birthday {
    
    using Address for address payable;
    
    uint256 private _present ;
    address private _owner;
    uint256 private _birthday;

    constructor(address owner_, uint256 birthday_) {
        _owner = owner_;
        _birthday = birthday_;
    }
    
    modifier onlyOwner {
        require(msg.sender == _owner, "Sorry, this isn't your birthday!");
        _;
    }
    
    modifier onTime {
        require(_birthday <= block.timestamp, "Not your B-Day yet!");
        _;
    }
    
    modifier notOwner {
        require(msg.sender != _owner, "Looks like you have nothing to do here!");
        _;
    }
    
    function offer() external payable {
        _present += msg.value;
    }
    
    receive() external payable {
        _present += msg.value;
    }
    
    fallback() external {
        
    }
    
    function viewPresent() public view notOwner returns (uint256) {
        return _present;
    }
    
    function getPresent() public payable onlyOwner onTime {
        payable(msg.sender).sendValue(_present);
        _present = 0;
    }
    
    function getBDay() public view returns (uint256) {
        return _birthday; 
    }
    
    function getTime() public view returns (uint256) {
        return block.timestamp; 
    }
}