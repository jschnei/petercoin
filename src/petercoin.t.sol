pragma solidity ^0.4.13;

import "ds-test/test.sol";

import "./petercoin.sol";

contract petercoinTest is DSTest {
    petercoin petercoin;

    function setUp() {
        petercoin = new petercoin();
    }

    function testFail_basic_sanity() {
        assert(false);
    }

    function test_basic_sanity() {
        assert(true);
    }
}
