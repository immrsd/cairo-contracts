#[starknet::contract(account)]
pub(crate) mod DualCaseEthAccountMock {
    use crate::EthAccountComponent;
    use crate::interface::EthPublicKey;
    use openzeppelin_introspection::src5::SRC5Component;

    component!(path: EthAccountComponent, storage: eth_account, event: EthAccountEvent);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);

    #[abi(embed_v0)]
    impl SRC6Impl = EthAccountComponent::SRC6Impl<ContractState>;
    #[abi(embed_v0)]
    impl SRC6CamelOnlyImpl = EthAccountComponent::SRC6CamelOnlyImpl<ContractState>;
    #[abi(embed_v0)]
    impl DeclarerImpl = EthAccountComponent::DeclarerImpl<ContractState>;
    #[abi(embed_v0)]
    impl DeployableImpl = EthAccountComponent::DeployableImpl<ContractState>;
    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;
    impl EthAccountInternalImpl = EthAccountComponent::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub eth_account: EthAccountComponent::Storage,
        #[substorage(v0)]
        pub src5: SRC5Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        EthAccountEvent: EthAccountComponent::Event,
        #[flat]
        SRC5Event: SRC5Component::Event
    }

    #[constructor]
    fn constructor(ref self: ContractState, public_key: EthPublicKey) {
        self.eth_account.initializer(public_key);
    }
}

#[starknet::contract(account)]
pub(crate) mod SnakeEthAccountMock {
    use crate::EthAccountComponent;
    use crate::interface::EthPublicKey;
    use openzeppelin_introspection::src5::SRC5Component;

    component!(path: EthAccountComponent, storage: eth_account, event: EthAccountEvent);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);

    #[abi(embed_v0)]
    impl SRC6Impl = EthAccountComponent::SRC6Impl<ContractState>;
    #[abi(embed_v0)]
    impl PublicKeyImpl = EthAccountComponent::PublicKeyImpl<ContractState>;
    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;
    impl EthAccountInternalImpl = EthAccountComponent::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub eth_account: EthAccountComponent::Storage,
        #[substorage(v0)]
        pub src5: SRC5Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        EthAccountEvent: EthAccountComponent::Event,
        #[flat]
        SRC5Event: SRC5Component::Event
    }

    #[constructor]
    fn constructor(ref self: ContractState, public_key: EthPublicKey) {
        self.eth_account.initializer(public_key);
    }
}

#[starknet::contract(account)]
pub(crate) mod CamelEthAccountMock {
    use crate::EthAccountComponent;
    use crate::interface::EthPublicKey;
    use openzeppelin_introspection::src5::SRC5Component;
    use starknet::account::Call;

    component!(path: EthAccountComponent, storage: eth_account, event: EthAccountEvent);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);

    #[abi(embed_v0)]
    impl SRC6CamelOnlyImpl = EthAccountComponent::SRC6CamelOnlyImpl<ContractState>;
    #[abi(embed_v0)]
    impl PublicKeyCamelImpl =
        EthAccountComponent::PublicKeyCamelImpl<ContractState>;
    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;
    impl SRC6Impl = EthAccountComponent::SRC6Impl<ContractState>;
    impl EthAccountInternalImpl = EthAccountComponent::InternalImpl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub eth_account: EthAccountComponent::Storage,
        #[substorage(v0)]
        pub src5: SRC5Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        EthAccountEvent: EthAccountComponent::Event,
        #[flat]
        SRC5Event: SRC5Component::Event
    }

    #[constructor]
    fn constructor(ref self: ContractState, publicKey: EthPublicKey) {
        self.eth_account.initializer(publicKey);
    }

    #[abi(per_item)]
    #[generate_trait]
    impl ExternalImpl of ExternalTrait {
        #[external(v0)]
        fn __execute__(self: @ContractState, mut calls: Array<Call>) -> Array<Span<felt252>> {
            self.eth_account.__execute__(calls)
        }

        #[external(v0)]
        fn __validate__(self: @ContractState, mut calls: Array<Call>) -> felt252 {
            self.eth_account.__validate__(calls)
        }
    }
}

// Although these modules are designed to panic, functions
// still need a valid return value. We chose:
//
// 3 for felt252
// false for bool

#[starknet::contract]
pub(crate) mod SnakeEthAccountPanicMock {
    use crate::interface::EthPublicKey;
    use starknet::SyscallResultTrait;
    use starknet::secp256_trait::Secp256Trait;

    #[storage]
    pub struct Storage {}

    #[abi(per_item)]
    #[generate_trait]
    impl ExternalImpl of ExternalTrait {
        #[external(v0)]
        fn set_public_key(
            ref self: ContractState, new_public_key: EthPublicKey, signature: Span<felt252>
        ) {
            panic!("Some error");
        }

        #[external(v0)]
        fn get_public_key(self: @ContractState) -> EthPublicKey {
            panic!("Some error");
            Secp256Trait::secp256_ec_new_syscall(3, 3).unwrap_syscall().unwrap()
        }

        #[external(v0)]
        fn is_valid_signature(
            self: @ContractState, hash: felt252, signature: Array<felt252>
        ) -> felt252 {
            panic!("Some error");
            3
        }

        #[external(v0)]
        fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
            panic!("Some error");
            false
        }
    }
}

#[starknet::contract]
pub(crate) mod CamelEthAccountPanicMock {
    use crate::interface::EthPublicKey;
    use starknet::SyscallResultTrait;
    use starknet::secp256_trait::Secp256Trait;

    #[storage]
    pub struct Storage {}

    #[abi(per_item)]
    #[generate_trait]
    impl ExternalImpl of ExternalTrait {
        #[external(v0)]
        fn setPublicKey(
            ref self: ContractState, newPublicKey: EthPublicKey, signature: Span<felt252>
        ) {
            panic!("Some error");
        }

        #[external(v0)]
        fn getPublicKey(self: @ContractState) -> EthPublicKey {
            panic!("Some error");
            Secp256Trait::secp256_ec_new_syscall(3, 3).unwrap_syscall().unwrap()
        }

        #[external(v0)]
        fn isValidSignature(
            self: @ContractState, hash: felt252, signature: Array<felt252>
        ) -> felt252 {
            panic!("Some error");
            3
        }

        #[external(v0)]
        fn supportsInterface(self: @ContractState, interfaceId: felt252) -> bool {
            panic!("Some error");
            false
        }
    }
}
