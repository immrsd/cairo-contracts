use core::num::traits::Zero;
use openzeppelin::access::ownable::dual_ownable::DualCaseOwnable;
use openzeppelin::access::ownable::dual_ownable::DualCaseOwnableTrait;
use openzeppelin::access::ownable::interface::IOwnableCamelOnlyDispatcher;
use openzeppelin::access::ownable::interface::IOwnableDispatcher;
use openzeppelin::access::ownable::interface::IOwnableDispatcherTrait;
use openzeppelin::tests::mocks::non_implementing_mock::NonImplementingMock;
use openzeppelin::tests::mocks::ownable_mocks::{
    CamelOwnableMock, CamelOwnablePanicMock, SnakeOwnableMock, SnakeOwnablePanicMock
};
use openzeppelin::tests::utils::common::declare_and_deploy;
use openzeppelin::tests::utils::constants::{OWNER, NEW_OWNER};
use openzeppelin::utils::serde::SerializedAppend;
use snforge_std::start_cheat_caller_address;

//
// Setup
//

fn setup_snake() -> (DualCaseOwnable, IOwnableDispatcher) {
    let mut calldata = array![];
    calldata.append_serde(OWNER());
    let target = declare_and_deploy("SnakeOwnableMock", calldata);
    (DualCaseOwnable { contract_address: target }, IOwnableDispatcher { contract_address: target })
}

fn setup_camel() -> (DualCaseOwnable, IOwnableCamelOnlyDispatcher) {
    let mut calldata = array![];
    calldata.append_serde(OWNER());
    let target = declare_and_deploy("CamelOwnableMock", calldata);
    (
        DualCaseOwnable { contract_address: target },
        IOwnableCamelOnlyDispatcher { contract_address: target }
    )
}

fn setup_non_ownable() -> DualCaseOwnable {
    let calldata = array![];
    let target = declare_and_deploy("NonImplementingMock", calldata);
    DualCaseOwnable { contract_address: target }
}

fn setup_ownable_panic() -> (DualCaseOwnable, DualCaseOwnable) {
    let snake_target = declare_and_deploy("SnakeOwnablePanicMock", array![]);
    let camel_target = declare_and_deploy("CamelOwnablePanicMock", array![]);
    (
        DualCaseOwnable { contract_address: snake_target },
        DualCaseOwnable { contract_address: camel_target }
    )
}

//
// Case agnostic methods
//

#[test]
fn test_dual_owner() {
    let (snake_dispatcher, _) = setup_snake();
    let (camel_dispatcher, _) = setup_camel();

    let snake_owner = snake_dispatcher.owner();
    assert_eq!(snake_owner, OWNER());

    let camel_owner = camel_dispatcher.owner();
    assert_eq!(camel_owner, OWNER());
}

#[test]
#[should_panic(
    expected: (
        "Entry point selector 0x02016836a56b71f0d02689e69e326f4f4c1b9057164ef592671cf0d37c8040c0 not found in contract 0x036958e39c33afae916e4122aa060d535d9f24414e93789e90eb69ff894a0853",
    )
)]
fn test_dual_no_owner() {
    let dispatcher = setup_non_ownable();
    dispatcher.owner();
}

#[test]
#[should_panic(expected: ("Some error",))]
fn test_dual_owner_exists_and_panics() {
    let (dispatcher, _) = setup_ownable_panic();
    dispatcher.owner();
}

//
// snake_case target
//

#[test]
fn test_dual_transfer_ownership() {
    let (dispatcher, target) = setup_snake();
    start_cheat_caller_address(dispatcher.contract_address, OWNER());
    dispatcher.transfer_ownership(NEW_OWNER());

    let current_owner = target.owner();
    assert_eq!(current_owner, NEW_OWNER());
}

#[test]
#[should_panic(
    expected: (
        "Entry point selector 0x02a3bb1eaa05b77c4b0eeee0116a3177c6d62319dd7149ae148185d9e09de74a not found in contract 0x036958e39c33afae916e4122aa060d535d9f24414e93789e90eb69ff894a0853",
    )
)]
fn test_dual_no_transfer_ownership() {
    let dispatcher = setup_non_ownable();
    dispatcher.transfer_ownership(NEW_OWNER());
}

#[test]
#[should_panic(expected: ("Some error",))]
fn test_dual_transfer_ownership_exists_and_panics() {
    let (dispatcher, _) = setup_ownable_panic();
    dispatcher.transfer_ownership(NEW_OWNER());
}

#[test]
fn test_dual_renounce_ownership() {
    let (dispatcher, target) = setup_snake();
    start_cheat_caller_address(dispatcher.contract_address, OWNER());
    dispatcher.renounce_ownership();

    let current_owner = target.owner();
    assert!(current_owner.is_zero());
}

#[test]
#[should_panic(
    expected: (
        "Entry point selector 0x00052580a92c73f4428f1a260c5d768ef462b25955307de00f99957df119865d not found in contract 0x036958e39c33afae916e4122aa060d535d9f24414e93789e90eb69ff894a0853",
    )
)]
fn test_dual_no_renounce_ownership() {
    let dispatcher = setup_non_ownable();
    dispatcher.renounce_ownership();
}

#[test]
#[should_panic(expected: ("Some error",))]
fn test_dual_renounce_ownership_exists_and_panics() {
    let (dispatcher, _) = setup_ownable_panic();
    dispatcher.renounce_ownership();
}

//
// camelCase target
//

#[test]
#[ignore]
fn test_dual_transferOwnership() {
    let (dispatcher, _) = setup_camel();
    start_cheat_caller_address(dispatcher.contract_address, OWNER());
    dispatcher.transfer_ownership(NEW_OWNER());

    let current_owner = dispatcher.owner();
    assert_eq!(current_owner, NEW_OWNER());
}

#[test]
#[ignore]
#[should_panic(expected: ("Some error",))]
fn test_dual_transferOwnership_exists_and_panics() {
    let (_, camel_dispatcher) = setup_ownable_panic();
    camel_dispatcher.transfer_ownership(NEW_OWNER());
}

#[test]
#[ignore]
fn test_dual_renounceOwnership() {
    let (dispatcher, _) = setup_camel();
    start_cheat_caller_address(dispatcher.contract_address, OWNER());
    dispatcher.renounce_ownership();

    let current_owner = dispatcher.owner();
    assert!(current_owner.is_zero());
}

#[test]
#[ignore]
#[should_panic(expected: ("Some error",))]
fn test_dual_renounceOwnership_exists_and_panics() {
    let (_, camel_dispatcher) = setup_ownable_panic();
    camel_dispatcher.renounce_ownership();
}

