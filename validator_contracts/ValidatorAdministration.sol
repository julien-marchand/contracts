//! An administration contract which draws from the current set of validators.
//! Majority support is required to enact events.
//! Signatures should be collected offline or with a wrapper contract.
//!
//! Copyright Parity Technologies Ltd (UK), 2017.
//! By Robert Habermeier, 2017.
//! Released under the Apache Licence 2.

pragma solidity ^0.4.16;

import "./base/ValidatorManaged.sol";
import "./base/Administration.sol";

/// Validator set based administration. Requires signatures to be collected
/// offline, although a wrapper contract could be implemented to collect signatures
/// online.
contract ValidatorBasedAdministration is Administration, ValidatorManaged {
    uint256 nonce;

    // pass 3 arrays for the signatures, where the i'th signature
    // is obtained from (v[i], r[i], s[i]).
    modifier validSigLength(uint8[] v, bytes32[] r, bytes32[] s) {
        assert(v.length == r.length && r.length == s.length);
        _;
    }

    function ValidatorBasedAdministration(ValidatorSet _validators)
        ValidatorManaged(_validators)
        public
    {}

    // utility function for decomposing a 65-byte signature into a v, r, s
    function decomposeSig(bytes sig)
        public pure returns (uint8 v, bytes32 r, bytes32 s)
    {
        assert(sig.length == 65);

        r = bytes32(0);
        s = bytes32(0);

        for (uint i = 0; i < 32; i++) {
            r = r | (bytes32(sig[i]) >> i * 8);
            s = s | (bytes32(sig[i + 32]) >> i * 8);
        }

        v = uint8(sig[64]);

        return (v, r, s);
    }

    // produce the operation hash to sign for a set balance operation.
    function setBalanceOpHash(address target, uint256 newBalance)
        public constant returns (bytes32)
    {
        return keccak256(target, newBalance, nonce);
    }

    // set the balance of the given account to the new balance, with supporting signatures
    // from a majority of validators.
    function setBalance(address target, uint256 newBalance, uint8[] v, bytes32[] r, bytes32[] s)
        public validSigLength(v, r, s)
    {
        bytes32 opHash = setBalanceOpHash(target, newBalance);
        checkValidatorMajority(opHash, v, r, s);

        SetBalance(target, newBalance);
    }

    // produce the operation hash to sign for a set code operation.
    function setCodeOpHash(address target, bytes newCode)
        public constant returns (bytes32)
    {
        return keccak256(target, newCode, nonce);
    }

    // set the code of the given account to the new code, with supporting signatures
    // from a majority of validators.
    function setCode(address target, bytes newCode, uint8[] v, bytes32[] r, bytes32[] s)
        public validSigLength(v, r, s)
    {
        bytes32 opHash = setCodeOpHash(target, newCode);
        checkValidatorMajority(opHash, v, r, s);

        SetCode(target, newCode);
    }

    // produce the operation hash to sign for a set code operation.
    function setStorageOpHash(address target, bytes32 key, bytes32 value)
        public constant returns (bytes32)
    {
        return keccak256(target, key, value, nonce);
    }

    // set the code of the given account to the new code, with supporting signatures
    // from a majority of validators.
    function setStorage(address target, bytes32 key, bytes32 value, uint8[] v, bytes32[] r, bytes32[] s)
        public validSigLength(v, r, s)
    {
        bytes32 opHash = setStorageOpHash(target, key, value);
        checkValidatorMajority(opHash, v, r, s);

        SetStorage(target, key, value);
    }
}
