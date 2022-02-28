const { expect } = require("chai");
const { ethers } = require("hardhat");
const { BigNumber } = ethers;

describe("Bank contract", () => {
  const mineBlocks = async (blocksToMine) => {
    let startBlock = await ethers.provider.getBlockNumber();
    let timestamp = (await ethers.provider.getBlock(startBlock)).timestamp;
    for (let i = 1; i <= blocksToMine; ++i) {
      await ethers.provider.send("evm_mine", [timestamp + i * 13]);
    }
    let endBlock = await ethers.provider.getBlockNumber();
    expect(endBlock).equals(startBlock + blocksToMine);
  }

  beforeEach("Deployment setup", async () => {
    [owner, acc1, acc2, acc3] = await ethers.getSigners();
    bankFactory = await ethers.getContractFactory('Bank');
    bank = await bankFactory.deploy();
    // provide some eth to the bank to pay the interest
    ethAmount = ethers.utils.parseEther('50.0');
    await bank.deposit(ethAmount, { value: ethAmount });

    bank1 = bank.connect(acc1);
    bank2 = bank.connect(acc2);
    bank3 = bank.connect(acc3);
  });

  describe("deposit", async () => {
    it("deposit eth", async () => {
      let amountBefore = await ethers.provider.getBalance(bank.address);
      let amount = ethers.utils.parseEther('10.0');
      await bank1.deposit(amount, { value: amount });
      expect(await ethers.provider.getBalance(bank.address)).equals(amountBefore.add(amount));
      expect(await bank1.getBalance()).equals(amount);
    });
  });

  describe("withdraw", async function () {
    it("without balance", async function () {
      let amount = ethers.utils.parseEther('100');
      await expect(bank1.withdraw(amount)).to.be.revertedWith("no balance");
    });

    it("balance too low", async function () {
      let amount = BigNumber.from(100);
      await bank1.deposit(amount, { value: amount });
      await expect(bank1.withdraw(amount.add(10))).to.be.revertedWith("amount exceeds balance");
    });
    it('withdraws with interest', async () => {
      let amount = ethers.utils.parseEther('100');
      await bank1.deposit(amount, {value: amount});
      await mineBlocks(99);
      await expect(bank1.withdraw(ethers.utils.parseEther('100')))
        .to.emit(bank, "Withdraw")
        .withArgs(await acc1.getAddress(), ethers.utils.parseEther('103'));
    });
  });

  describe("interest", async function () {
    it("100 blocks", async function () {
      let amount = ethers.utils.parseEther('100');
      await bank1.deposit(amount, { value: amount });
      await mineBlocks(99);
      await expect(bank1.withdraw(0))
        .to.emit(bank, "Withdraw")
        .withArgs(await acc1.getAddress(), ethers.utils.parseEther('103'));
    });

    it("150 blocks", async function () {
      let amount = ethers.utils.parseEther('100');
      await bank1.deposit(amount, { value: amount });
      await mineBlocks(149);
      await expect(bank1.withdraw(0))
        .to.emit(bank, "Withdraw")
        .withArgs(await acc1.getAddress(), ethers.utils.parseEther('104.5'));
      // (1 + 0.03 * 150/100) * 10000
    });

    it("250 blocks", async function () {
      let amount = ethers.utils.parseEther('100');
      await bank1.deposit(amount, { value: amount });
      await mineBlocks(249);
      await expect(bank1.withdraw(0))
        .to.emit(bank, "Withdraw")
        .withArgs(await acc1.getAddress(), ethers.utils.parseEther('107.50'));
      // (1 + 0.03 * 250/100) * 10000
    });

    it("1311 blocks", async function () {
      let amount = ethers.utils.parseEther('100');
      await bank1.deposit(amount, { value: amount });
      await mineBlocks(1310);
      await expect(bank1.withdraw(0))
        .to.emit(bank, "Withdraw")
        .withArgs(await acc1.getAddress(), ethers.utils.parseEther('139.33'));
      // (1 + 0.03 * 1311/100) * 10000
    });

    it("200 blocks in 2 steps", async function () {
      let amount = ethers.utils.parseEther('100');
      // deposit once, wait 100 blocks and check balance
      await bank1.deposit(amount, { value: amount });
      await mineBlocks(100);
      expect(await bank1.getBalance()).equals(ethers.utils.parseEther('103'));

      // deposit again to trigger account update, wait 100 blocks and withdraw all
      await bank1.deposit(amount, { value: amount });
      await mineBlocks(99);
      await expect(bank1.withdraw(0))
        .to.emit(bank, "Withdraw")
        .withArgs(await acc1.getAddress(),
          ethers.utils.parseEther('209.1209')
        );
    });
  });
});