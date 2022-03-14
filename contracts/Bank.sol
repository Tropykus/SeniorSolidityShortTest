// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./IBank.sol";

/// @title Implementation of IBank interface
/// @author Jesus Steer Varela
contract Bank is IBank {
    
    /// Transfer ether from account to the contract
    /// @param amount the value to deposit
    /// @dev increases the balance for the account
    function deposit(uint256 amount) external payable override returns (bool) {
        return true;
    }

    /// Return the balance for an account.
    /// @dev retrieves the value of the state variable `storedData`
    /// @return the stored balance
    function getBalance() external view override returns (uint256) {
        return 0;
    }

    /// Transfer ether from the contract to an account
    /// @param amount the new value to store
    /// @dev increases the balance for the account
    function withdraw(uint256 amount) external override returns (uint256) {
        return 0;
    }

}
