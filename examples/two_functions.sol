// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.10;

contract TwoFunctions {
    function panic() pure public {
        assert(false);
    }

    function do_nothing() public {}

    function boo(bool s) public {}
}
