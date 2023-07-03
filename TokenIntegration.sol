//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./MyERC721.sol";
import "./MyERC20.sol";

contract TokenIntegration {
    MyERC721 private erc721Contract;
    MyERC20 private erc20Contract;

    mapping(uint256 => uint256) private tokenToERC20;

    constructor(address erc721Address, address erc20Address) {
        erc721Contract = MyERC721(erc721Address);
        erc20Contract = MyERC20(erc20Address);
    }

    function linkTokens(uint256 tokenId) external {
        require(
            erc721Contract.ownerOf(tokenId) == msg.sender,
            "You are not the owner of the token"
        );

        require(
            tokenToERC20[tokenId] == 0,
            "The token is already linked to an ERC20 token"
        );

        uint256 erc20Amount = 1000;
        erc20Contract.mint(msg.sender, erc20Amount);

        tokenToERC20[tokenId] = erc20Amount;
    }

    function unlinkTokens(uint256 tokenId) external {
        require(
            erc721Contract.ownerOf(tokenId) == msg.sender,
            "You are not the owner of the token"
        );

        require(
            tokenToERC20[tokenId] != 0,
            "The token is not linked to any ERC20 token"
        );

        uint256 erc20Amount = tokenToERC20[tokenId];
        erc20Contract.burn(msg.sender, erc20Amount);

        delete tokenToERC20[tokenId];
    }

    function transferERC721(
        address to,
        uint256 tokenId
    ) external {
        require(
            erc721Contract.ownerOf(tokenId) == msg.sender,
            "You are not the owner of the token"
        );

        erc721Contract.safeTransferFrom(msg.sender, to, tokenId);
    }

    function transferERC20(
        address to,
        uint256 amount
    ) external {
        require(
            erc20Contract.balanceOf(msg.sender) >= amount,
            "Insufficient ERC20 balance"
        );

        erc20Contract.transfer(to, amount);
    }
}
