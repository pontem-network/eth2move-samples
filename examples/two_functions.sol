// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.10;

contract TwoFunctions {
    // # panic() !panic
    function panic() pure public {
        assert(false);
    }

    // # do_nothing()
    // # do_nothing(123) void !panic
    function do_nothing() public {}

    // # boo(true)
    // # boo(false)
    // # boo(123) !panic
    function boo(bool s) public {
    }
}
