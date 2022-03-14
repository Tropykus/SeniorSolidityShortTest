// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./IBank.sol";

/**
* The purpose of this contract is to implement the IBank interface.
* @title Bank contract.
* @author Jesus Steer Varela.
*/
contract Bank is IBank {
    
    mapping (address => Account) private AccountBalance;

    /**
     * Return the accumulated interest for the given account.
     * @dev calculate interest rate on deposits, which is 3% per 100 blocks.
     * @return interest the calculated interest.
     */
    function getInterest() public view returns (uint256) {
        uint256 accumulatedBlocks = block.number - AccountBalance[msg.sender].lastInterestBlock;
        uint256 interest = (accumulatedBlocks * 3 * AccountBalance[msg.sender].deposit) / 10000;
        return interest;
    }

    /**
     * Transfer ether from account to the contract.
     * @param amount the value to deposit.
     * @dev increases the balance for the account.
     */
    function deposit(uint256 amount) external payable override returns (bool) {
        require(msg.value == amount, "you can't contribute with a different amount");
        require(amount > 0, "you can't deposit 0 ether");
        AccountBalance[msg.sender].deposit += amount + getInterest();
        AccountBalance[msg.sender].lastInterestBlock = block.number;
        emit Deposit(msg.sender, amount);
        return true;
    }

    /**
     * Return the balance for an account.
     * @dev retrieves the value of the state variable `balance`.
     * @return balance the stored balance.
     */
    function getBalance() external view override returns (uint256) {
        uint256 balance = AccountBalance[msg.sender].deposit + getInterest();
        return balance;
    }

    /**
     * Transfer ether from the contract to an account.
     * @param amount the value to withdraw.
     * @dev decreases the balance for the account.
     */
    function withdraw(uint256 amount) external override returns (uint256) {
        if (amount == 0) {
            amount = AccountBalance[msg.sender].deposit;
        }
        require(AccountBalance[msg.sender].deposit != 0, "no balance");
        require(AccountBalance[msg.sender].deposit + getInterest() > amount, "amount exceeds balance");
        amount += getInterest();
        address payable user = payable(msg.sender);
        require(user.send(amount), "withdrawal failed");
        AccountBalance[msg.sender].deposit += getInterest();
        AccountBalance[msg.sender].lastInterestBlock = block.number;
        AccountBalance[msg.sender].deposit -= amount;
        emit Withdraw(msg.sender, amount);
        return 0;
    }
}
