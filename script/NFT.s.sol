// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Script } from "forge-std/Script.sol";
import { NFT } from "../src/NFT.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployNFT is Script {
    NFT internal nft;

    function run() public {
        vm.startBroadcast();
        nft = new NFT("test", "TST");
        vm.stopBroadcast();
    }
}
