// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.10;

contract APlusB {
    function plus() public pure returns (uint) {
        return plus_1(13, 14);
    }

    function plus_1(uint a, uint b) public pure returns (uint) {
        return a + b;
    }

    function minus() public pure returns (uint) {
        return 14 - 13;
    }
}
