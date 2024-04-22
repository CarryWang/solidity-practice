// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./BaseERC20.sol";

contract TokenBank {
    mapping(address => uint256) public bankBalances;

    function deposit(
        address tokenAddress,
        uint256 _value
    ) public returns (bool) {
        IERC20(tokenAddress).transferFrom(msg.sender, address(this), _value);

        bankBalances[msg.sender] += _value;

        return true;
    }

    function withdraw(
        address tokenAddress,
        uint256 _value
    ) public returns (bool) {
        require(bankBalances[msg.sender] >= _value, "Insufficient balance");
        IERC20(tokenAddress).transfer(msg.sender, _value);

        bankBalances[msg.sender] -= _value;

        return true;
    }
}
