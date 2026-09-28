// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Test} from "forge-std/Test.sol";
import {Deploy} from "../script/Deploy.s.sol";
import {Room} from "../src/Room.sol";

contract DeployTest is Test {
    Deploy internal script;

    function setUp() public {
        script = new Deploy();
    }

    function test_deployProducesAWorkingRoom() public {
        Room room = script.deploy();
        assertGt(address(room).code.length, 0);
        assertEq(room.agentCount(), 2);
        assertEq(room.deskLabel(1), "seat 2");
        assertEq(room.deskLabel(2), "desk 2");
        assertEq(room.deskLabel(3), "open");
    }

    function test_checkAcceptsAllowedChains() public view {
        script.check(0, 1);
        script.check(31337, 31337);
        script.check(11155111, 11155111);
    }

    function test_checkRejectsMismatch() public {
        vm.expectRevert(abi.encodeWithSelector(Deploy.UnexpectedChain.selector, 11155111, 1));
        script.check(11155111, 1);
    }

    function test_checkRejectsDisallowedTarget() public {
        vm.expectRevert(abi.encodeWithSelector(Deploy.ChainNotAllowed.selector, 1));
        script.check(1, 1);
    }

    function testFuzz_checkRejectsUnknownChains(uint256 expected, uint256 actual) public {
        vm.assume(expected != 0 && expected != 31337 && expected != 11155111);
        vm.expectRevert(abi.encodeWithSelector(Deploy.ChainNotAllowed.selector, expected));
        script.check(expected, actual);
    }
}
