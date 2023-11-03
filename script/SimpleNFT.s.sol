// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import "forge-std/Script.sol";
import "forge-std/console.sol";
import "../src/SimpleNFT.sol";

contract SimpleNFTScript is Script {
    function setUp() public {}

    function run() public {
        uint privateKey = vm.envUint("MUMBAI_PRIVATE_KEY");
        address account = vm.addr(privateKey);

        console.log("Account:", account);

        vm.startBroadcast(privateKey);

        // deploy SimpleNFT contract
        SimpleNFT nft = new SimpleNFT();

        nft.safeMint(account, 1);

        vm.stopBroadcast();
    }
}
