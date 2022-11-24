// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import { Script } from "forge-std/Script.sol";
import { Deposit } from "../src/Deposit.sol";
import { HelperConfig } from "./HelperConfig.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployDeposit is Script {
    Deposit internal deposit;

    function run() public {
        vm.startBroadcast();
        deposit = new Deposit();
        vm.stopBroadcast();
    }
}
