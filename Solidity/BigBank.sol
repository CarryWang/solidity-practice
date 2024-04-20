// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Back {
    mapping(address => uint256) balances;
    address public admin;
    address[3] public top3;

    constructor() {
        admin = msg.sender;
    }

    function deposit() public payable virtual {
        balances[msg.sender] += msg.value;
        updateTop3(msg.sender);
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    function withdraw(uint256 amount) public payable virtual onlyAdmin {
        require(amount <= address(this).balance, "Insufficient balance");
        payable(admin).transfer(amount);
    }

    function updateTop3(address user) private {
        uint256 balance = balances[user];
        for (uint256 i = 0; i < top3.length; i++) {
            if (balance > balances[top3[i]]) {
                for (uint256 j = top3.length - 1; j > i; j--) {
                    top3[j] = top3[j - 1];
                }
                top3[i] = user;
                break;
            }
        }
    }
}

contract Ownable {
    address public owner;
    address public bankAddress;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    function transferOwnership(address _bankAddress) public onlyOwner {
        require(_bankAddress != address(0), "Invalid address");
        owner = IBank(_bankAddress).getAdmin();
        bankAddress = _bankAddress;
    }

    function withdraw(uint256 amount) public {
        require(
            bankAddress != address(0),
            "Please call transferOwnership first"
        );
        IBank(bankAddress).withdraw(amount);
    }
}

interface IBank {
    function getAdmin() external view returns (address);

    function withdraw(uint256 amount) external payable;
}

contract BigBank is Back, IBank {
    function transferAdmin(address newAdmin) public onlyAdmin {
        admin = newAdmin;
    }

    function getAdmin() public view returns (address) {
        return admin;
    }

    modifier checkMinDeposit() {
        require(
            msg.value >= 0.001 ether,
            "Deposit amount must be at least 0.001 ether"
        );
        _;
    }

    function deposit() public payable override checkMinDeposit {
        super.deposit();
    }

    function withdraw(uint256 amount) public payable override(Back, IBank) {
        super.withdraw(amount);
    }
}
