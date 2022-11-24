// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.4;

import "forge-std/Test.sol";
import { Deposit } from "../src/Deposit.sol";
import { MockERC20 } from "../src/MockERC20.sol";
import { SigUtils } from "../src/SigUtils.sol";

/// @dev See the "Writing Tests" section in the Foundry Book if this is your first time with Forge.
/// https://book.getfoundry.sh/forge/writing-tests
contract DepositTest is Test {
    Deposit internal deposit;
    MockERC20 internal token;
    SigUtils internal sigUtils;

    uint256 internal ownerPrivateKey;
    address internal owner;

    function setUp() public {
        deposit = new Deposit();
        token = new MockERC20();
        sigUtils = new SigUtils(token.DOMAIN_SEPARATOR());

        ownerPrivateKey = 0xA11CE;
        owner = vm.addr(ownerPrivateKey);

        token.mint(owner, 1e18);
    }

    function test_DepositWithLimitedPermit() public {
        SigUtils.Permit memory permit = SigUtils.Permit({
            owner: owner,
            spender: address(deposit),
            value: 1e18,
            nonce: token.nonces(owner),
            deadline: 1 days
        });

        bytes32 digest = sigUtils.getTypedDataHash(permit);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

        deposit.depositWithPermit(
            address(token),
            1e18,
            permit.owner,
            permit.spender,
            permit.value,
            permit.deadline,
            v,
            r,
            s
        );

        assertEq(token.balanceOf(owner), 0);
        assertEq(token.balanceOf(address(deposit)), 1e18);

        assertEq(token.allowance(owner, address(deposit)), 0);
        assertEq(token.nonces(owner), 1);

        assertEq(deposit.userDeposits(owner, address(token)), 1e18);
    }

    function test_DepositWithMaxPermit() public {
        SigUtils.Permit memory permit = SigUtils.Permit({
            owner: owner,
            spender: address(deposit),
            value: type(uint256).max,
            nonce: token.nonces(owner),
            deadline: 1 days
        });

        bytes32 digest = sigUtils.getTypedDataHash(permit);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerPrivateKey, digest);

        deposit.depositWithPermit(
            address(token),
            1e18,
            permit.owner,
            permit.spender,
            permit.value,
            permit.deadline,
            v,
            r,
            s
        );

        assertEq(token.balanceOf(owner), 0);
        assertEq(token.balanceOf(address(deposit)), 1e18);

        assertEq(token.allowance(owner, address(deposit)), type(uint256).max);
        assertEq(token.nonces(owner), 1);

        assertEq(deposit.userDeposits(owner, address(token)), 1e18);
    }
}
