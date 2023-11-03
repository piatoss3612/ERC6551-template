// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "forge-std/Test.sol";

import "../src/interfaces/IERC6551Account.sol";
import "../src/interfaces/IERC6551Registry.sol";
import "../src/ERC6551Account.sol";
import "../src/ERC6551Registry.sol";
import "./mocks/MockERC721.sol";

contract ERC6551RegistryTest is Test {
    ERC6551Registry registry;
    ERC6551Account implementation;
    MockERC721 token;

    function setUp() public {
        registry = new ERC6551Registry();
        implementation = new ERC6551Account();
        token = new MockERC721();

        assertEq(type(IERC6551Account).interfaceId, bytes4(0x6faff5f1));
        assertEq(type(IERC6551Registry).interfaceId, bytes4(0xae3ec50e));
    }

    function testCreateAccount() public {
        uint256 chainId = 80001;
        address tokenContract = address(token);
        uint256 tokenId = 1;
        bytes32 salt = bytes32(uint256(1234));

        address expected = registry.account(
            address(implementation),
            salt,
            chainId,
            tokenContract,
            tokenId
        );

        console.log("Expected:", expected);

        address actual = registry.createAccount(
            address(implementation),
            salt,
            chainId,
            tokenContract,
            tokenId
        );

        console.log("Actual:", actual);

        assertEq(actual, expected);
    }
}
