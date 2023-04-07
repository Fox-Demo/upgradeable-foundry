//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import {Box, BoxV2, IBox} from "../src/Box.sol";
import {TransparentUpgradeableProxy} from "../src/Transparent.sol";

contract TransparentTest is Test {
    uint256 private _userPrivateKey = vm.envUint("USER_KEY");

    TransparentUpgradeableProxy proxy;
    Box impl;
    BoxV2 impl2;

    function setUp() external {
        impl = new Box();
        impl2 = new BoxV2();
        bytes memory data = abi.encodeWithSignature("initialize(uint256)", 1);
        proxy = new TransparentUpgradeableProxy(address(impl), address(this), data);
    }

    function testVersion() external {
        vm.prank(vm.addr(_userPrivateKey));
        assertEq(IBox(address(proxy)).getVersion(), "Box version --> 1");
    }

    function testUpgrade() external {
        proxy.upgradeTo(address(impl2));
        vm.prank(vm.addr(_userPrivateKey));
        assertEq(IBox(address(proxy)).getVersion(), "Box version --> 2");
    }
}
