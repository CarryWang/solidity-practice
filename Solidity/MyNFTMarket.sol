// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyERC20.sol";
import "./MyERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import {IReceiver} from "./IReceiver.sol";

contract NFTMarket is IERC721Receiver, IReceiver {
    mapping(uint256 => uint256) public tokenIdPrice;
    mapping(uint256 => address) public tokenSeller;
    address public immutable token;
    address public immutable nftToken;

    constructor(address _token, address _nftToken) {
        token = _token;
        nftToken = _nftToken;
    }

    function onERC721Received(address, address, uint256, bytes calldata) external pure override returns (bytes4) {
        // tokenIdPrice[tokenId] = abi.decode(data, (uint));
        // tokenSeller[tokenId] = msg.sender;
        return this.onERC721Received.selector;
    }

    // approve(address to, uint256 tokenId) first
    function list(uint256 tokenId, uint256 amount) external returns (bool) {
        // bytes memory data = abi.encode(amount);
        IERC721(nftToken).safeTransferFrom(msg.sender, address(this), tokenId, "");
        tokenIdPrice[tokenId] = amount;
        tokenSeller[tokenId] = msg.sender;

        return true;
    }

    function buy(uint256 tokenId, uint256 amount) external returns (bool) {
        require(amount >= tokenIdPrice[tokenId], "low price");

        require(IERC721(nftToken).ownerOf(tokenId) == address(this), "aleady selled");

        IERC20(token).transferFrom(msg.sender, tokenSeller[tokenId], tokenIdPrice[tokenId]);
        IERC721(nftToken).transferFrom(address(this), msg.sender, tokenId);
        return true;
    }

    function tokensReceived(address _from, uint256 amount, bytes calldata data) public returns (bool) {
        require(_from == token, "invalid caller");

        uint256 tokenId = abi.decode(data, (uint256));

        require(tokenIdPrice[tokenId] <= amount, "payment value is less than list price");

        IERC20(token).transfer(tokenIdSeller[tokenId], amount);
        IERC721(nftToken).safeTransferFrom(address(this), _from, tokenId);
        return true;
    }
}
