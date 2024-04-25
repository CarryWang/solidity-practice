// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "./MyERC20.sol";
import {IReceiver} from "./IReceiver.sol";

contract TokenBank is IReceiver {
    mapping(address => uint256) public bankBalances;
    address public immutable token;

    constructor(address _token) {
        token = _token;
    }

    function deposit(uint256 _value) public returns (bool) {
        IERC20(token).transferFrom(msg.sender, address(this), _value);

        bankBalances[msg.sender] += _value;

        return true;
    }

    function withdraw(uint256 _value) public returns (bool) {
        require(bankBalances[msg.sender] >= _value, "Insufficient balance");
        IERC20(token).transfer(msg.sender, _value);

        bankBalances[msg.sender] -= _value;

        return true;
    }

    function tokensReceived(
        address _from,
        uint256 _value,
        bytes calldata
    ) public returns (bool) {
        bankBalances[_from] += _value;
        return true;
    }
}
