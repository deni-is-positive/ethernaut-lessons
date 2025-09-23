// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SampleContract{

    function callerChecker() public view returns (uint256){
        uint256 x;

        assembly {
            x := extcodesize(caller())
        }

        return x;
    }

    function callerAddr() public view returns (address addr){
        assembly {
            addr := caller()
        }
    }
}

contract Caller{

    function callSample(address _sampleAddr) public returns ( uint256, uint256){
        uint256 x = SampleContract(_sampleAddr).callerChecker();
        (bool success, bytes memory data) = _sampleAddr.delegatecall(abi.encodeWithSignature("callerChecker()"));
        require(success == true);
        uint256 y = abi.decode(data, (uint256));
        require(x > 0);
        require(y == 0); // since it is using delegatecall
        return (x, y);
    }

    function callTheCallerAddr(address _sampleAddr) public returns (address addr1, address addr2){
        addr1 = SampleContract(_sampleAddr).callerAddr(); // address of this Caller Contract
        (bool success, bytes memory data) = _sampleAddr.delegatecall(abi.encodeWithSignature("callerAddr()"));
        require(success == true);
        addr2 = abi.decode(data, (address)); // address of the User who is calling the function
    }
}