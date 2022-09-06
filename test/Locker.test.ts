import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ContractFactory, Signer } from "ethers";
import { ethers } from "hardhat";
import { Locker } from "../src/types/contracts";

describe("Locker Contract test", function() {
  let Instance: ContractFactory;
  let Locker: Locker;
  let user1: SignerWithAddress;
  let user2: SignerWithAddress;
  let user3: SignerWithAddress;
  let addrs: SignerWithAddress[];

  beforeEach(async function() {
    [user1, user2, user3, ...addrs] = await ethers.getSigners();

    Instance = await ethers.getContractFactory("Locker");
    Locker = (await Instance.deploy()) as Locker;
  });

  describe("Deposit Tests", function() {
    it("Should fail to deposit - (No Deposit Amount)", async function() {
      await expect(Locker.deposit()).to.be.revertedWith("no amount deposited");
    });

    it("Should successfully deposit", async function() {
      await Locker.deposit({ value: ethers.utils.parseEther("1") });

      const user1Address = await user1.getAddress();

      expect(await Locker.balanceOf(user1Address)).to.be.equal(
        ethers.utils.parseEther("1")
      );
    });
  });

  describe("Withdraw Tests", function() {
    it("Should fail to withdraw - (withdraw amount exceeding)", async function() {
      await expect(
        Locker.withdraw(ethers.utils.parseEther("1"))
      ).to.be.revertedWith("withdraw amount exceeds deposited");
    });

    it("Should fail to withdraw - (withdrawing whole amount)", async function() {
      await Locker.deposit({ value: ethers.utils.parseEther("1") });

      await expect(
        Locker.withdraw(ethers.utils.parseEther("1"))
      ).to.be.revertedWith("withdrawing whole amount");
    });

    it("Should withdraw successfully", async function() {
      await Locker.deposit({ value: ethers.utils.parseEther("1") });

      await Locker.withdraw(ethers.utils.parseEther("0.5"));

      const user1Address = await user1.getAddress();

      expect(await Locker.balanceOf(user1Address)).to.be.equal(
        ethers.utils.parseEther("0.5")
      );
    });
  });

  describe("Balance Check", function() {
    it("Should have the right balance", async function() {
      await Locker.deposit({ value: ethers.utils.parseEther("1") });
      await Locker.deposit({ value: ethers.utils.parseEther("1") });
      await Locker.deposit({ value: ethers.utils.parseEther("1") });

      expect(await Locker.getBalance()).to.be.equal(
        ethers.utils.parseEther("3")
      );
    });
  });
});
