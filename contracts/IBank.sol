pragma solidity 0.8.0;

interface IBank {
    struct Account {
        // Note that token values have an 18 decimal precision
        uint256 deposit; // accumulated deposits made into the account
        uint256 lastInterestBlock; // block at which interest was last computed
    }

    // Event emitted when a user makes a deposit
    event Deposit(
        address indexed _from, // account of user who deposited
        uint256 amount // amount of token that was deposited
    );

    // Event emitted when a user makes a withdrawal
    event Withdraw(
        address indexed _from, // account of user who withdrew funds
        uint256 amount // amount of token that was withdrawn
    );

    /**
     * The purpose of this function is to allow end-users to deposit a given
     * ETH amount into their bank account.
     * @param amount - the amount of the given token to deposit.
     * @return - true if the deposit was successful, otherwise revert.
     */
    function deposit(uint256 amount) external payable returns (bool);

    /**
     * The purpose of this function is to allow end-users to withdraw a given
     * ETH amount from their bank account. Upon withdrawal, the user must
     * automatically receive a 3% interest rate per 100 blocks on their deposit.
     * @param amount - the amount of the given token to withdraw. If this param
     *                 is set to 0, then the maximum amount available in the
     *                 caller's account should be withdrawn.
     * @return - the amount that was withdrawn plus interest upon success,
     *           otherwise revert.
     */
    function withdraw(uint256 amount) external returns (uint256);

    /**
     * The purpose of this function is to return the balance that the caller
     * has in their own account (including interest).
     * @return - the value of the caller's balance with interest, excluding debts.
     */
    function getBalance() external view returns (uint256);
}
