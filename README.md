# Solidity Senior Short Test

The following technical test has been designed to demonstrate skills of our senior solidity developers.

## The Challenge
For this challenge you must develop the project according to the guidelines
- [ ] Fork this repository with your GitHub account
- [ ] Commit regularly to check your progress
- [ ] Email us the repository URL

## The Project
The goal of this phase is to develop a set of smart contracts that conforms to a given interface and passes a given test suite.

1. Build a smart contract system that can be used as a simple saving system.
2. Tropykus provides the [interface](#mandatory-interface) that **MUST** be used for the implementation
3. Tropykus will provide a test suite available through this base repository.

## Requirements and Artifacts
### Functional Requirements
In the following text, we use the terms "user" and "bank customer" interchangeably. The functional requirements must be satisfied by the implementation of the smart contracts.

1. A bank customer's account is represented by their wallet address.
2. A bank customer must be able to deposit an amount higher than 0 of tokens into their own account. Deposits can be made on ETH solely for the purpose of this challenge.
3. A bank customer must be able to withdraw only up to the amount deposited into their own account plus any interest accrued.
4. The interes rate on deposits is 3% per 100 blocks. If a user withdraws their deposit earlier or later than 100 blocks, they will receive a proportional interes amount.
5. A bank customer must be able to deposit as many times as they wish into the same account, and if so, the interes should be *accounted* for each time deposit and withdraw are called by the user.
6. The smart contract must have plenty ETH to subsidy the interest accrued by the user (**Note**: This is where this test gets shorter, we eliminated the collateral, borrowing and repay borrow functionalities).
7. Each state-changing function defined in the `IBank` interface, must emit the corresponding event defined at the top of that interface with the correct parameters as specified in the code comments for each event.

### Non-Functional Requirements
1. The implementation **MUST** use Solidity version 0.7.0. Neither other specific version is going to be considered nor a range that even includes the specified version.

### Mandatory Interface
The interface has been provided at the [contracts folder](/contracts/IBank.sol).