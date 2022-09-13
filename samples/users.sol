// SPDX-License-Identifier: Apache-2.0

pragma solidity ^0.8.0;

contract Users {
    struct User {
        uint256 id;
        bool is_admin;
        uint256 balance;
    }

    uint256 seq;
    mapping(address => User) user_store;
    address owner;

    event Transfer(address from, address to, uint256 amount);
    event NewUser(address addr, bool is_admin, uint256 amount);

    constructor(address admin) {
       owner = admin;
       seq = 1;
       user_store[admin] = User(seq, true, 10000000000000000000000000000);
    }

    function create_user() public {
        require(user_store[msg.sender].id == 0);
        seq = seq + 1;
        user_store[msg.sender] = User(seq, false, 0);
        emit NewUser(msg.sender, false, 0);
    }

    function get_id() public view returns (uint256) {
        return user_store[msg.sender].id;
    }

    function is_owner() public view returns (bool) {
        return user_store[msg.sender].is_admin;
    }

    function get_balance() public view returns (uint256) {
        return user_store[msg.sender].balance;
    }

    function transfer(address to, uint256 amount) public {
        require(user_store[msg.sender].balance >= amount);
        user_store[msg.sender].balance = user_store[msg.sender].balance - amount;
        user_store[to].balance = user_store[to].balance + amount;
        emit Transfer(msg.sender, to, amount);
    }
}
