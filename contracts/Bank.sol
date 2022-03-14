// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./IBank.sol";

/// @title Implementation of IBank interface
/// @author Jesus Steer Varela
contract Bank is IBank {
    
    mapping (address => Account) private AccountBalance;

    /// Transfer ether from account to the contract
    /// @param amount the value to deposit
    /// @dev increases the balance for the account
    function deposit(uint256 amount) external payable override returns (bool) {
        require(msg.value == amount, "you can't contribute with a different amount");
        require(amount > 0, "you can't deposit 0 ether");
        AccountBalance[msg.sender].deposit += amount;
        AccountBalance[msg.sender].lastInterestBlock = block.number;
        emit Deposit(msg.sender, amount);
        return true;
    }

    /// Return the balance for an account.
    /// @dev retrieves the value of the state variable `balance`
    /// @return the stored balance
    function getBalance() external view override returns (uint256) {
        return AccountBalance[msg.sender].deposit;
    }

    /// Transfer ether from the contract to an account
    /// @param amount the value to withdraw
    /// @dev decreases the balance for the account
    function withdraw(uint256 amount) external override returns (uint256) {
        require(AccountBalance[msg.sender].deposit != 0, "no balance");
        require(AccountBalance[msg.sender].deposit > amount, "amount exceeds balance");
        address payable user = payable(msg.sender);
        require(user.send(amount), "withdrawal failed");
        AccountBalance[msg.sender].deposit += amount;
        AccountBalance[msg.sender].lastInterestBlock = block.number;
        emit Withdraw(msg.sender, amount);
        return 0;
    }

}
