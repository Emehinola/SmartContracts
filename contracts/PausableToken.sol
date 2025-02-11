// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract PausableToken {

    address public owner;
    bool public paused;
    mapping ( address => uint ) public balances;

    constructor () {
        owner = msg.sender;
        paused = false;
        balances[owner] = 1000;
    }

    modifier onlyOwner() {
        require( owner == msg.sender, "Only the owner can perform this transaction" );
        _;
    }

    modifier notPaused () {
        require ( paused == false, "The contract is paused" );
        _;
    }

    function pause () public onlyOwner {
        paused = true;
    }

    function unpause () public onlyOwner {
        paused = false;
    }


    function transfer( address to, uint amount ) public notPaused {
        require (balances[msg.sender] > amount, "Insufficient balance");

        balances[msg.sender] -= amount; // debit sender
        balances[to] += amount; // credit receiver
    }

}