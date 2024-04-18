// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyContract {
    // =========================================================
    // Variables & Data Types

    // State Variables
    // uint是uint256的缩写形式
    uint256 public myUnit = 1;
    uint256 public myUint256 = 1;
    int256 public myInt = -1;

    string public myString = "hello world";
    bytes32 public myBytes32 = "hello world";

    address public myAddress = 0xa0466a82B961e85077d4a8DEBC35fbF6Cf18D464;

    // 结构体需要先定义,花括号后不需要加分号
    struct MyStruct {
        uint256 myUint256;
        string myString;
    }

    // 创建结构体实例
    MyStruct public myStruct = MyStruct(1, "hello world");

    // Local Variables
    // pure 关键词是指函数内容不会影响链上数据,不会存储在链上
    function getValue() public pure returns (uint256) {
        uint256 value = 1;
        return value;
    }

    // =========================================================
    // Arrays

    // Arrays
    uint256[] public uintArray = [1, 2, 3];
    string[] public stringArray = ["apple", "banana", "peach"];
    string[] public values;
    uint256[][] public array2D = [[1, 2, 3], [4, 5, 6]];

    function addValue(string memory _value) public {
        values.push(_value);
    }

    function valueCount() public view returns (uint256) {
        return values.length;
    }

    // =========================================================
    // Mappings
    // mapping (key => value) myMapping
    mapping(uint256 => string) public names;

    // constructor() {
    //     names[1] = "Adam";
    //     names[2] = "Bruce";
    //     names[3] = "Carl";
    // }

    mapping(uint256 => Book) public books;

    struct Book {
        string title;
        string author;
    }

    function addBook(
        uint256 _id,
        string memory _title,
        string memory _author
    ) public {
        books[_id] = Book(_title, _author);
    }

    // 嵌套map
    mapping(address => mapping(uint256 => Book)) public myBooks;

    function addMyBook(
        uint256 _id,
        string memory _title,
        string memory _author
    ) public {
        // msg.sender 调用合约的人
        myBooks[msg.sender][_id] = Book(_title, _author);
    }

    // =========================================================
    // Conditionals & Loops

    uint256[] public numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function countEvenNumbers() public view returns (uint256) {
        uint256 count = 0;

        for (uint256 i = 0; i < numbers.length; i++) {
            if (isEvenNumber(numbers[i])) {
                count++;
            }
        }

        return count;
    }

    function isEvenNumber(uint256 _number) public pure returns (bool) {
        if (_number % 2 == 0) {
            return true;
        } else {
            return false;
        }
    }

    function isOwner() public view returns (bool) {
        return (msg.sender == owner);
    }
}
