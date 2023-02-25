// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "openzeppelin-contracts/contracts/proxy/utils/Initializable.sol";

interface IBox {
    function getVersion() external returns (string memory);
}

contract Box is IBox, Initializable {
    uint256 num;

    function initialize(uint256 _value) external initializer {
        num = _value;
    }

    function getVersion() external pure returns (string memory) {
        return "Box version --> 1";
    }
}

contract BoxV2 is IBox, Initializable {
    uint256 num;

    function initialize(uint256 _value) external reinitializer(2) {
        num = _value;
    }

    function getVersion() external pure returns (string memory) {
        return "Box version --> 2";
    }
}
