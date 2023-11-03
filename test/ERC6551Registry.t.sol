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

    event ERC6551AccountCreated(
        address account,
        address indexed implementation,
        bytes32 salt,
        uint256 chainId,
        address indexed tokenContract,
        uint256 indexed tokenId
    );

    function setUp() public {
        registry = new ERC6551Registry();
        implementation = new ERC6551Account();
        token = new MockERC721();

        assertEq(type(IERC6551Account).interfaceId, bytes4(0x6faff5f1));
        assertEq(type(IERC6551Registry).interfaceId, bytes4(0xae3ec50e));
    }

    function test_CreateAccount() public {
        // mint a NFT to the sender
        token.mint(msg.sender, 1);

        assertEq(token.ownerOf(1), msg.sender);

        // retrieve the chainId
        uint chainId;
        assembly {
            chainId := chainid()
        }

        address tokenContract = address(token);
        uint256 tokenId = 1;
        bytes32 salt = bytes32(uint256(1234));

        // get the expected result of createAccount call
        address expected = registry.account(
            address(implementation),
            salt,
            chainId,
            tokenContract,
            tokenId
        );

        console.log("Expected:", expected);

        // expect ERC6551AccountCreated event
        vm.expectEmit(true, true, true, true);

        emit ERC6551AccountCreated(
            expected,
            address(implementation),
            salt,
            chainId,
            tokenContract,
            tokenId
        );

        // call createAccount on the registry
        address actual = registry.createAccount(
            address(implementation),
            salt,
            chainId,
            tokenContract,
            tokenId
        );

        console.log("Actual:", actual);

        assertEq(actual, expected);

        // check the account is created correctly
        ERC6551Account account = ERC6551Account(payable(actual));

        (
            uint256 actualChainId,
            address actualTokenContract,
            uint256 actualTokenId
        ) = account.token();

        assertEq(actualChainId, chainId);
        assertEq(actualTokenContract, tokenContract);
        assertEq(actualTokenId, tokenId);

        console.log("Owner:", account.owner());

        assertEq(account.owner(), msg.sender);

        // TODO: test execute function
    }
}
