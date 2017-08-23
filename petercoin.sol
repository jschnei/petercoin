pragma solidity ^0.4.10;


contract PeterCoin {
    address owner;

    mapping (address => uint256) balances;
    address[] accounts;

    uint lastUpdated;
    uint constant TRIGGER_TIME = 4 weeks;
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Trigger();

    function name() constant returns (string) { return "PeterCoin"; }
    function symbol() constant returns (string) { return "PET"; }

    function PeterCoin() {
        owner = msg.sender;
        balances[owner] = 1000;
        accounts.push(owner);
        lastUpdated = now;
    }

    function balanceOf(address _owner) constant returns (uint256) { return balances[_owner]; }

    function transfer(address _to, uint256 _value) returns (bool success) {

        if (_value == 0) { 
            return false; 
        }

        uint256 fromBalance = balances[msg.sender];

        bool sufficientFunds = fromBalance >= _value;
        bool overflowed = balances[_to] + _value < balances[_to];

        if (sufficientFunds && !overflowed) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;

            Transfer(msg.sender, _to, _value);
            return true;
        }

        return false;
    }

    function numTrailingZeros(bytes32 byteString) internal returns (uint256 factor) {

        factor = 1;
        for (uint i = 0; i < 32; i++) {
            bytes1 curByte = byteString[i];
            for (int j = 0; j < 8; j++) {
                if ((curByte & 1) == 0) {
                    curByte <<= 1;
                    factor >>= 1;
                } else {
                    return factor;
                }
            }
        }
        return factor;
    }

    function canTrigger() constant returns (bool) { return (now - lastUpdated > TRIGGER_TIME);}

    function trigger() returns (bool success) {
        uint currentTime = now;
        if (currentTime - lastUpdated > TRIGGER_TIME) {
            lastUpdated = currentTime;
            for (uint i = 0; i < accounts.length; i++) {
                address account = accounts[i];
                bytes32 hashCode = sha256(block.number, account);

                uint factor = numTrailingZeros(hashCode);
                balances[account] *= factor;
            }
            Trigger();
            return true;
        } else {
            return false;
        }
    }
}