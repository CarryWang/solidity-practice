// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IReceiver {
    function tokensReceived(
        address _from,
        uint256 _value,
        bytes calldata data
    ) external returns (bool);
}
