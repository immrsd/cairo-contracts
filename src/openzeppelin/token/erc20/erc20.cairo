#[contract]
mod ERC20Library {
    use starknet::get_caller_address;
    use starknet::contract_address_const;
    use starknet::ContractAddressZeroable;
    use zeroable::Zeroable;

    struct Storage {
        _name: felt,
        _symbol: felt,
        _total_supply: u256,
        _balances: LegacyMap::<ContractAddress, u256>,
        _allowances: LegacyMap::<(ContractAddress, ContractAddress), u256>,
    }

    #[event]
    fn Transfer(from: ContractAddress, to: ContractAddress, value: u256) {}

    #[event]
    fn Approval(owner: ContractAddress, spender: ContractAddress, value: u256) {}

    // TMP starknet testing isn't fully functional.
    // Use to ensure paths are correctly set.
    fn mock_initializer(name_: felt, symbol_: felt) {
        _name::write(name_);
        _symbol::write(symbol_);
    }

    fn initializer(name_: felt, symbol_: felt, initial_supply: u256, recipient: ContractAddress) {
        _name::write(name_);
        _symbol::write(symbol_);
        _mint(recipient, initial_supply);
    }

    fn name() -> felt {
        _name::read()
    }

    fn symbol() -> felt {
        _symbol::read()
    }

    fn decimals() -> u8 {
        18_u8
    }

    fn total_supply() -> u256 {
        _total_supply::read()
    }

    fn balance_of(account: ContractAddress) -> u256 {
        _balances::read(account)
    }

    fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256 {
        _allowances::read((owner, spender))
    }

    fn transfer(recipient: ContractAddress, amount: u256) -> bool {
        let sender = get_caller_address();
        _transfer(sender, recipient, amount);
        true
    }

    fn transfer_from(sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool {
        let caller = get_caller_address();
        _spend_allowance(sender, caller, amount);
        _transfer(sender, recipient, amount);
        true
    }

    fn approve(spender: ContractAddress, amount: u256) -> bool {
        let caller = get_caller_address();
        _approve(caller, spender, amount);
        true
    }

    fn increase_allowance(spender: ContractAddress, added_value: u256) -> bool {
        let caller = get_caller_address();
        _approve(caller, spender, _allowances::read((caller, spender)) + added_value);
        true
    }

    fn decrease_allowance(spender: ContractAddress, subtracted_value: u256) -> bool {
        let caller = get_caller_address();
        _approve(caller, spender, _allowances::read((caller, spender)) - subtracted_value);
        true
    }

    fn _mint(recipient: ContractAddress, amount: u256) {
        assert(!recipient.is_zero(), 'ERC20: mint to 0');
        _total_supply::write(_total_supply::read() + amount);
        _balances::write(recipient, _balances::read(recipient) + amount);
        Transfer(contract_address_const::<0>(), recipient, amount);
    }

    fn _burn(account: ContractAddress, amount: u256) {
        assert(!account.is_zero(), 'ERC20: burn from 0');
        _total_supply::write(_total_supply::read() - amount);
        _balances::write(account, _balances::read(account) - amount);
        Transfer(account, contract_address_const::<0>(), amount);
    }

    fn _approve(owner: ContractAddress, spender: ContractAddress, amount: u256) {
        assert(!owner.is_zero(), 'ERC20: approve from 0');
        assert(!spender.is_zero(), 'ERC20: approve to 0');
        _allowances::write((owner, spender), amount);
        Approval(owner, spender, amount);
    }

    fn _transfer(sender: ContractAddress, recipient: ContractAddress, amount: u256) {
        assert(!sender.is_zero(), 'ERC20: transfer from 0');
        assert(!recipient.is_zero(), 'ERC20: transfer to 0');
        _balances::write(sender, _balances::read(sender) - amount);
        _balances::write(recipient, _balances::read(recipient) + amount);
        Transfer(sender, recipient, amount);
    }

    fn _spend_allowance(owner: ContractAddress, spender: ContractAddress, amount: u256) {
        let current_allowance = _allowances::read((owner, spender));
        let ONES_MASK = 0xffffffffffffffffffffffffffffffff_u128;
        let is_unlimited_allowance =
            current_allowance.low == ONES_MASK & current_allowance.high == ONES_MASK;
        if !is_unlimited_allowance {
            _approve(owner, spender, current_allowance - amount);
        }
    }
}