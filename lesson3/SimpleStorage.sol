// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

contract SimpleStorage {
    // boolean, uint, int, address, bytes
    uint favoriteNumer;

    mapping(string => uint) public nameToFavoriteNumber; 

    struct People {
        uint favoriteNumer;
        string name;
    }

    People[] public peopleList;

    function store(uint _favoriteNumber) public virtual {
        favoriteNumer = _favoriteNumber;
    }

    // view, pure
    function retrieve() public view returns(uint256){
        return favoriteNumer;
    } 

    function addPerson(uint _favoriteNumber, string memory _name) public {
        peopleList.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

    
}

// 0xd9145CCE52D386f254917e481eB44e9943F39138
