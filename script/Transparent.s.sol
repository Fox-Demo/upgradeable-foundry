// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import {Box, BoxV2, IBox} from "../src/Box.sol";
import {TransparentUpgradeableProxy} from "../src/Transparent.sol";

contract Deploy is Script {
    uint256 userPrivateKey = vm.envUint("USER_KEY");

    TransparentUpgradeableProxy proxy;
    Box impl;
    BoxV2 impl2;

    function _setUp() internal {
        impl = new Box();
        impl2 = new BoxV2();
        bytes memory data = abi.encodeWithSignature("initialize(uint256)", 1);
        proxy = new TransparentUpgradeableProxy(address(impl), address(this), data);
    }

    function run() external {
        _setUp();

        //contract version
        console.log("Contract version: ", IBox(address(proxy)).getVersion());

        _consoleVersion(userPrivateKey); // version --> 1
        _upgrade(address(impl2));
        console.log("Upgrade Success!!");
        _consoleVersion(userPrivateKey); // version --> 2
    }

    function _upgrade(address newImpl) internal {
        proxy.upgradeTo(address(newImpl));
    }

    function _consoleVersion(uint256 privateKey) internal {
        vm.prank(vm.addr(privateKey));
        console.log(IBox(address(proxy)).getVersion());
    }
}
