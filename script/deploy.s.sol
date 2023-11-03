// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/SimpleNFT.sol";
import "../src/ERC6551Account.sol";
import "../src/ERC6551Registry.sol";

contract DeployScript is Script {
    uint privateKey;

    function setUp() public {
        privateKey = vm.envUint("MUMBAI_PRIVATE_KEY");
    }

    function run() public {
        address account = vm.addr(privateKey);

        console.log("Account:", account);

        vm.startBroadcast(privateKey);

        // deploy SimpleNFT contract
        SimpleNFT nft = new SimpleNFT();

        // deploy ERC6551Account contract
        ERC6551Account erc6551Account = new ERC6551Account();

        // deploy ERC6551Registry contract
        ERC6551Registry erc6551Registry = new ERC6551Registry();

        // log the address of the deployed contracts
        console.log("SimpleNFT:", address(nft));
        console.log("ERC6551Account:", address(erc6551Account));
        console.log("ERC6551Registry:", address(erc6551Registry));

        // mint NFT with id 1 to account
        nft.mint(account, 1);

        // check if account is owner of NFT with id 1
        require(
            nft.ownerOf(1) == account,
            "account is not owner of NFT with id 1"
        );

        uint chainId;
        assembly {
            chainId := chainid()
        }
        bytes32 salt = bytes32(uint256(1234));

        // get the expected result of createAccount call
        address expected = erc6551Registry.account(
            address(erc6551Account),
            salt,
            chainId,
            address(nft),
            1
        );

        // create TBA for NFT with id 1
        address actual = erc6551Registry.createAccount(
            address(erc6551Account),
            salt,
            chainId,
            address(nft),
            1
        );

        // check if the actual result is the same as the expected result
        require(actual == expected, "actual != expected");

        console.log("TBA Account:", actual);

        vm.stopBroadcast();
    }
}
