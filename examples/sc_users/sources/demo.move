module sc::ScUser {
    use sc::Users;

    public entry fun constructor(account_address: &signer) {
        Users::constructor(account_address);
    }

    public entry fun create_user(account_address: &signer) {
        Users::create_user(account_address);
    }

    public entry fun is_id(account_address: &signer, id: u128) {
        let guid = Users::get_id(account_address);
        assert!(guid == Users::from_u128(id), 1);
    }

    public entry fun is_owner(account_address: &signer) {
        assert!(Users::is_owner(account_address), 2);
    }

    public entry fun check_balance(account_address: &signer, balance: u128) {
        assert!(Users::get_balance(account_address) == Users::from_u128(balance), 3);
    }

    public entry fun is_empty_balance(account_address: &signer) {
        assert!(Users::get_balance(account_address) == Users::from_u128(0), 4);
    }

    public entry fun transfer(account_address: &signer, to: address, amount: u128) {
        Users::transfer(account_address, to, Users::from_u128(amount));
    }
}

