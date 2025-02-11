// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

contract ExpenseTracker {

    // Expense struct
    struct Expense {
        address user;
        string name;
        uint256 amount;
    }

    // use contructor to add initial expenses
    constructor() {
        addExpense("Rice", 2300);
        addExpense("Oil", 5000);
        addExpense("Cookies", 6940);
    }

    Expense[] public expenses;

    // add expense
    function addExpense(string memory name, uint256 amount) public {
        Expense memory expense = Expense({
            user: msg.sender,
            name: name,
            amount: amount
        });
        expenses.push(expense);
    }

    // calculate the total expenses for a given user
    function calculateExpense(address _user) public view returns(uint) {
        uint sum = 0; // total expenses for the passed user

        for (uint i=0; i<expenses.length; i++) {
            Expense memory expense = expenses[i];
            if (expense.user == _user) {
                sum += expense.amount;
            }
        }

        return sum;
    }
}