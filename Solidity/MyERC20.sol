// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IReceiver} from "./IReceiver.sol";

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    function balanceOf(address _owner) external view returns (uint256 balance);

    function transfer(
        address _to,
        uint256 _value
    ) external returns (bool success);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool success);

    function approve(
        address _spender,
        uint256 _value
    ) external returns (bool success);

    function allowance(
        address _owner,
        address _spender
    ) external view returns (uint256 remaining);
}

contract BaseERC20 is IERC20 {
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;

    mapping(address => uint256) balances;

    mapping(address => mapping(address => uint256)) allowances;

    constructor() {
        // write your code here
        // set name,symbol,decimals,totalSupply
        name = "BaseERC20";
        symbol = "BERC20";
        decimals = 18;
        totalSupply = 100000000 * 10 ** decimals;
        balances[msg.sender] = totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        // write your code here
        return balances[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        // write your code here
        require(
            _value <= balances[msg.sender],
            "ERC20: transfer amount exceeds balance"
        );

        _transfer(msg.sender, _to, _value);

        return true;
    }

    function transferWithCallback(
        address _to,
        uint256 _value,
        bytes calldata data
    ) public returns (bool success) {
        _transfer(msg.sender, _to, _value);

        // Check if recipient is a contract
        if (_to.code.length > 0) {
            bool res = IReceiver(_to).tokensReceived(msg.sender, _value, data);
            require(res, "Transfer failed: tokensReceived not implemented");
        }

        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        // write your code here
        require(
            balances[_from] >= _value,
            "ERC20: transfer amount exceeds balance"
        );
        require(
            allowance(_from, msg.sender) >= _value,
            "ERC20: transfer amount exceeds allowance"
        );

        allowances[_from][msg.sender] -= _value;

        _transfer(_from, _to, _value);

        return true;
    }

    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        // write your code here
        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint256 remaining) {
        // write your code here
        return allowances[_owner][_spender];
    }

    function _transfer(address from, address to, uint256 amount) private {
        balances[from] -= amount;
        balances[to] += amount;
        emit Transfer(from, to, amount);
    }

    function isContract(address addr) internal view returns (bool) {
        uint256 size;
        assembly {
            size := extcodesize(addr)
        }
        return size > 0;
    }
}
