#[starknet::contract]
pub(crate) mod DualCaseERC721Mock {
    use crate::erc721::{ERC721Component, ERC721HooksEmptyImpl};
    use openzeppelin_introspection::src5::SRC5Component;
    use starknet::ContractAddress;

    component!(path: ERC721Component, storage: erc721, event: ERC721Event);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);

    // ERC721
    #[abi(embed_v0)]
    impl ERC721Impl = ERC721Component::ERC721Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC721MetadataImpl = ERC721Component::ERC721MetadataImpl<ContractState>;
    #[abi(embed_v0)]
    impl ERC721CamelOnly = ERC721Component::ERC721CamelOnlyImpl<ContractState>;
    #[abi(embed_v0)]
    impl ERC721MetadataCamelOnly =
        ERC721Component::ERC721MetadataCamelOnlyImpl<ContractState>;
    impl ERC721InternalImpl = ERC721Component::InternalImpl<ContractState>;

    // SRC5
    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub erc721: ERC721Component::Storage,
        #[substorage(v0)]
        pub src5: SRC5Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC721Event: ERC721Component::Event,
        #[flat]
        SRC5Event: SRC5Component::Event
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: ByteArray,
        symbol: ByteArray,
        base_uri: ByteArray,
        recipient: ContractAddress,
        token_id: u256
    ) {
        self.erc721.initializer(name, symbol, base_uri);
        self.erc721.mint(recipient, token_id);
    }
}

#[starknet::contract]
pub(crate) mod SnakeERC721Mock {
    use crate::erc721::{ERC721Component, ERC721HooksEmptyImpl};
    use openzeppelin_introspection::src5::SRC5Component;
    use starknet::ContractAddress;

    component!(path: ERC721Component, storage: erc721, event: ERC721Event);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);

    // ERC721
    #[abi(embed_v0)]
    impl ERC721Impl = ERC721Component::ERC721Impl<ContractState>;
    #[abi(embed_v0)]
    impl ERC721MetadataImpl = ERC721Component::ERC721MetadataImpl<ContractState>;
    impl ERC721InternalImpl = ERC721Component::InternalImpl<ContractState>;

    // SRC5
    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub erc721: ERC721Component::Storage,
        #[substorage(v0)]
        pub src5: SRC5Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC721Event: ERC721Component::Event,
        #[flat]
        SRC5Event: SRC5Component::Event
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: ByteArray,
        symbol: ByteArray,
        base_uri: ByteArray,
        recipient: ContractAddress,
        token_id: u256
    ) {
        self.erc721.initializer(name, symbol, base_uri);
        self.erc721.mint(recipient, token_id);
    }
}

#[starknet::contract]
pub(crate) mod CamelERC721Mock {
    use crate::erc721::ERC721Component::{ERC721Impl, ERC721MetadataImpl};
    use crate::erc721::{ERC721Component, ERC721HooksEmptyImpl};
    use openzeppelin_introspection::src5::SRC5Component;
    use starknet::ContractAddress;

    component!(path: ERC721Component, storage: erc721, event: ERC721Event);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);

    // ERC721
    #[abi(embed_v0)]
    impl ERC721CamelOnly = ERC721Component::ERC721CamelOnlyImpl<ContractState>;
    #[abi(embed_v0)]
    impl ERC721MetadataCamelOnly =
        ERC721Component::ERC721MetadataCamelOnlyImpl<ContractState>;
    impl ERC721InternalImpl = ERC721Component::InternalImpl<ContractState>;

    // SRC5
    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;

    #[storage]
    pub struct Storage {
        #[substorage(v0)]
        pub erc721: ERC721Component::Storage,
        #[substorage(v0)]
        pub src5: SRC5Component::Storage
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC721Event: ERC721Component::Event,
        #[flat]
        SRC5Event: SRC5Component::Event
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        name: ByteArray,
        symbol: ByteArray,
        base_uri: ByteArray,
        recipient: ContractAddress,
        token_id: u256
    ) {
        self.erc721.initializer(name, symbol, base_uri);
        self.erc721.mint(recipient, token_id);
    }

    /// The following external methods are included because they are case-agnostic
    /// and this contract should not embed the snake_case impl.
    #[abi(per_item)]
    #[generate_trait]
    impl ExternalImpl of ExternalTrait {
        #[external(v0)]
        fn approve(ref self: ContractState, to: ContractAddress, tokenId: u256) {
            self.erc721.approve(to, tokenId);
        }

        #[external(v0)]
        fn name(self: @ContractState) -> ByteArray {
            self.erc721.name()
        }

        #[external(v0)]
        fn symbol(self: @ContractState) -> ByteArray {
            self.erc721.symbol()
        }
    }
}

/// Although these modules are designed to panic, functions
/// still need a valid return value. We chose:
///
/// 3 for felt252
/// zero for ContractAddress
/// u256 { 3, 3 } for u256
#[starknet::contract]
pub(crate) mod SnakeERC721PanicMock {
    use core::num::traits::Zero;
    use starknet::ContractAddress;

    #[storage]
    pub struct Storage {}

    #[abi(per_item)]
    #[generate_trait]
    impl ExternalImpl of ExternalTrait {
        #[external(v0)]
        fn name(self: @ContractState) -> ByteArray {
            panic!("Some error");
            "3"
        }

        #[external(v0)]
        fn symbol(self: @ContractState) -> ByteArray {
            panic!("Some error");
            "3"
        }

        #[external(v0)]
        fn approve(ref self: ContractState, to: ContractAddress, token_id: u256) {
            panic!("Some error");
        }

        #[external(v0)]
        fn supports_interface(self: @ContractState, interface_id: felt252) -> bool {
            panic!("Some error");
            false
        }

        #[external(v0)]
        fn token_uri(self: @ContractState, token_id: u256) -> felt252 {
            panic!("Some error");
            3
        }

        #[external(v0)]
        fn balance_of(self: @ContractState, account: ContractAddress) -> u256 {
            panic!("Some error");
            u256 { low: 3, high: 3 }
        }

        #[external(v0)]
        fn owner_of(self: @ContractState, token_id: u256) -> ContractAddress {
            panic!("Some error");
            Zero::zero()
        }

        #[external(v0)]
        fn get_approved(self: @ContractState, token_id: u256) -> ContractAddress {
            panic!("Some error");
            Zero::zero()
        }

        #[external(v0)]
        fn is_approved_for_all(
            self: @ContractState, owner: ContractAddress, operator: ContractAddress
        ) -> bool {
            panic!("Some error");
            false
        }

        #[external(v0)]
        fn set_approval_for_all(
            ref self: ContractState, operator: ContractAddress, approved: bool
        ) {
            panic!("Some error");
        }

        #[external(v0)]
        fn transfer_from(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, token_id: u256
        ) {
            panic!("Some error");
        }

        #[external(v0)]
        fn safe_transfer_from(
            ref self: ContractState,
            from: ContractAddress,
            to: ContractAddress,
            token_id: u256,
            data: Span<felt252>
        ) {
            panic!("Some error");
        }
    }
}

#[starknet::contract]
pub(crate) mod CamelERC721PanicMock {
    use core::num::traits::Zero;
    use starknet::ContractAddress;

    #[storage]
    pub struct Storage {}

    #[abi(per_item)]
    #[generate_trait]
    impl ExternalImpl of ExternalTrait {
        #[external(v0)]
        fn tokenURI(self: @ContractState, tokenId: u256) -> felt252 {
            panic!("Some error");
            3
        }

        #[external(v0)]
        fn balanceOf(self: @ContractState, account: ContractAddress) -> u256 {
            panic!("Some error");
            u256 { low: 3, high: 3 }
        }

        #[external(v0)]
        fn ownerOf(self: @ContractState, tokenId: u256) -> ContractAddress {
            panic!("Some error");
            Zero::zero()
        }

        #[external(v0)]
        fn getApproved(self: @ContractState, tokenId: u256) -> ContractAddress {
            panic!("Some error");
            Zero::zero()
        }

        #[external(v0)]
        fn isApprovedForAll(
            self: @ContractState, owner: ContractAddress, operator: ContractAddress
        ) -> bool {
            panic!("Some error");
            false
        }

        #[external(v0)]
        fn setApprovalForAll(ref self: ContractState, operator: ContractAddress, approved: bool) {
            panic!("Some error");
        }

        #[external(v0)]
        fn transferFrom(
            ref self: ContractState, from: ContractAddress, to: ContractAddress, tokenId: u256
        ) {
            panic!("Some error");
        }

        #[external(v0)]
        fn safeTransferFrom(
            ref self: ContractState,
            from: ContractAddress,
            to: ContractAddress,
            tokenId: u256,
            data: Span<felt252>
        ) {
            panic!("Some error");
        }
    }
}
