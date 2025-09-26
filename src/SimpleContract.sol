// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleContract {

    uint256 public secretNumber;

    function sayHello() public pure returns (string memory){
        return "Hello User";
    }

    function setSecretNumber(uint256 _secretNumber) public {
        secretNumber = _secretNumber;
    }
}