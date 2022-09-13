module _::Users {
    public native fun constructor(account_address: &signer);

    public native fun create_user(account_address: &signer,);

    public native fun get_balance(account_address: &signer,): U256;

    public native fun get_id(account_address: &signer,): U256;

    public native fun is_owner(account_address: &signer,): bool;

    public native fun transfer(account_address: &signer,to: address, amount: U256);

    struct U256 has copy, drop, store {
        v0: u64,
        v1: u64,
        v2: u64,
        v3: u64,
    }

    public native fun as_u128(val: U256): u128;

    public native fun from_u128(val: u128): U256;
}