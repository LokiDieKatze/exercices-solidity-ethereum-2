// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol";

contract Birthday {
    
    using Address for address payable;
    
    address private _owner;
    uint256 private _birthday;

    event Offered(address indexed sender, uint256 value);

    constructor(address owner_, uint256 delay_) {
        _owner = owner_;
        _birthday = block.timestamp + delay_ * 1 days;
    }
    
    modifier onlyOwner {
        require(msg.sender == _owner, "Birthday: Sorry, this is not your birthday!");
        _;
    }
    
    modifier onTime {
        require(_birthday <= block.timestamp, "Birthday: Not your B-Day yet!");
        _;
    }
    
    modifier notOwner {
        require(msg.sender != _owner, "Birthday: You are not allowed to use this functionality!");
        _;
    }
    
    function offer() external payable {
        emit Offered(msg.sender, msg.value);
    }
    
    receive() external payable {
        emit Offered(msg.sender, msg.value);
    }
    
    
    function viewPresent() public view notOwner returns (uint256) {
        return address(this).balance;
    }
    
    function getPresent() public onlyOwner onTime {
        payable(msg.sender).sendValue(address(this).balance);
    }
    
    function getBDay() public view returns (uint256) {
        return _birthday; 
    }
    
    function getRemainingTime() public view returns (uint256) {
        require(_birthday >= block.timestamp, "Birthday: Birthday has past.");
        return _birthday - block.timestamp; 
    }
}