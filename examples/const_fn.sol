// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

library ConstFn {
    // # const_fn_10 () 10_u128
    function const_fn_10() public pure returns (uint) {
        return 10;
    }

    // # const_fn_426574676453456 () 426574676453456_u128
    function const_fn_426574676453456() public pure returns (uint) {
        return 426574676453456;
    }

    // # const_fn_true () true
    function const_fn_true() public pure returns (bool) {
        return true;
    }

    // # const_fn_90_plus_54 () 144_u128
    function const_fn_90_plus_54() public pure returns (uint) {
        uint a = 90;
        uint b = 54;
        return a + b;
    }

    // # const_fn_true_1() false
    function const_fn_true_1() public pure returns (bool) {
        bool a = false;
        bool b = true;
        return a == b;
    }
}
