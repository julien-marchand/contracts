//! A contract which performs non-standard state transitions with administrator privileges
//! by issuing log events.
//! Copyright Parity Technologies Ltd (UK), 2017.
//! By Robert Habermeier, 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.15;

/// An administration contract can issue events that are interpreted specially by the blockchain
/// consensus rules in order to modify the state in certain ways.
///
/// Authentication of what kinds of transactions are allowed to issue contract events
/// is implementation-specific
contract Administration {
    // Set the balance of the target to the new balance.
    event SetBalance(address indexed target, uint256 indexed newBalance);

    // Set the code of the account to the new byte array.
    event SetCode(address indexed target, bytes newCode);

    // Set the storage of the account with the given key.
    event SetStorage(address indexed target, bytes32 indexed key, bytes32 indexed value);
}