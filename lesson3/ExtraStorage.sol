// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

import "./SimpleStorage.sol";

contract ExtraStorage is SimpleStorage {

    function store(uint _favoriteNumber) public override {
        favoriteNumer = _favoriteNumber + 5;
    }

}