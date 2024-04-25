// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyERC721 is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() ERC721("CarryWang", "CW") {}

    //  QmXWpQHdnxsu5PzAC7ghgUnFS6YF4PxkJc4JKDTa8rVLJx

    // ipfs://QmXWpQHdnxsu5PzAC7ghgUnFS6YF4PxkJc4JKDTa8rVLJx
    function mint(
        address user,
        string memory tokenURI
    ) public returns (uint256) {
        uint256 newItemId = _tokenIds.current();
        _mint(user, newItemId);
        _setTokenURI(newItemId, tokenURI);

        _tokenIds.increment();
        return newItemId;
    }
}
