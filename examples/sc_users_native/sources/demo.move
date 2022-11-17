module sc::ScUsersNative {
    use sc::UsersNative;

    public entry fun constructor(account_address: &signer) {
        UsersNative::constructor(account_address);
    }

    public entry fun create_user(account_address: &signer) {
        UsersNative::create_user(account_address);
    }

    public entry fun is_id(account_address: &signer, id: u128) {
        let guid = UsersNative::get_id(account_address);
        assert!(guid == UsersNative::from_u128(id), 1);
    }

    public entry fun is_owner(account_address: &signer) {
        assert!(UsersNative::is_owner(account_address), 2);
    }

    public entry fun check_balance(account_address: &signer, balance: u128) {
        assert!(UsersNative::get_balance(account_address) == UsersNative::from_u128(balance), 3);
    }

    public entry fun is_empty_balance(account_address: &signer) {
        assert!(UsersNative::get_balance(account_address) == UsersNative::from_u128(0), 4);
    }

    public entry fun transfer(account_address: &signer, to: address, amount: u128) {
        UsersNative::transfer(account_address, to, UsersNative::from_u128(amount));
    }
}

