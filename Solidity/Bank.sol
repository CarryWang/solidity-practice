// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    mapping(address => uint) balances;
    address public admin;
    address[3] public top3;

    constructor() {
        admin = msg.sender;
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        updateTop3(msg.sender);
    }

    function updateTop3(address user) private {
        uint balance = balances[user];
        for (uint i = 0; i < top3.length; i++) {
            if (balance > balances[top3[i]]) {
                for (uint j = top3.length - 1; j > i; j--) {
                    top3[j] = top3[j - 1];
                }
                top3[i] = user;
                break;
            }
        }
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    function withdraw(uint amount) public payable onlyAdmin {
        require(amount <= address(this).balance, "Insufficient balance");
        payable(admin).transfer(amount);
    }
}
