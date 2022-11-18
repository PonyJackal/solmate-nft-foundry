// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Script } from "forge-std/Script.sol";
import { NFT } from "../src/NFT.sol";
import { HelperConfig } from "./HelperConfig.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployNFT is Script {
    NFT internal nft;

    function run() public {
        HelperConfig helperConfig = new HelperConfig();
        (string memory nftName, string memory nftSymbol, string memory nftBaseURI) = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        nft = new NFT(nftName, nftSymbol, nftBaseURI);
        vm.stopBroadcast();
    }
}
