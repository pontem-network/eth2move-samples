module sc::ScUserEth {
    use sc::Users;
    use std::vector;

    public entry fun constructor(account_address: &signer) {
        Users::constructor(account_address);
    }

    public entry fun create_user(account_address: &signer) {
        Users::create_user(account_address, vector::empty<u8>());
    }

    public entry fun is_id(account_address: &signer, id: vector<u8>) {
        let guid = Users::get_id(account_address, vector::empty<u8>());
        assert!(guid == id, 1);
    }

    public entry fun is_owner(account_address: &signer) {
        assert!(
            Users::is_owner(account_address, vector::empty<u8>())
                ==
                x"0000000000000000000000000000000000000000000000000000000000000001",
            2
        );
    }

    public entry fun check_balance(account_address: &signer, balance: vector<u8>) {
        assert!(Users::get_balance(account_address, vector::empty<u8>()) == balance, 3);
    }

    public entry fun is_empty_balance(account_address: &signer) {
        assert!(Users::get_balance(account_address, vector::empty<u8>()) == zero(), 4);
    }

    public entry fun transfer(account_address: &signer, to_amount: vector<u8>) {
        Users::transfer(account_address, to_amount);
    }

    fun zero(): vector<u8> {
        x"0000000000000000000000000000000000000000000000000000000000000000"
    }
}

