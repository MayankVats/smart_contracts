import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { Contract } from "ethers";
import { ethers, network } from "hardhat";
import {
  address as cTokenAddress,
  abi as cTokenAbi,
} from "../abis/CTokenMainnet";

import {
  abi as comptrollerAbi,
  address as comptrollerAddress,
} from "../abis/ComptrollerMainnet";

import {
  abi as cEtherAbi,
  address as cEtherAddress,
} from "../abis/CEtherMainnet";

describe("Compound Finance", function () {
  let cToken: Contract;
  let comptroller: Contract;
  let cEther: Contract;
  let admin: SignerWithAddress;

  let user1: SignerWithAddress;
  let addrs: SignerWithAddress[];

  beforeEach(async function () {
    [user1, ...addrs] = await ethers.getSigners();

    cToken = await ethers.getContractAt(cTokenAbi, cTokenAddress);
    comptroller = await ethers.getContractAt(
      comptrollerAbi,
      comptrollerAddress
    );
    cEther = await ethers.getContractAt(cEtherAbi, cEtherAddress);

    await network.provider.request({
      method: "hardhat_impersonateAccount",
      params: ["0x6d903f6003cca6255D85CcA4D3B5E5146dC33925"],
    });

    admin = await ethers.getSigner(
      "0x6d903f6003cca6255D85CcA4D3B5E5146dC33925"
    );
  });

  describe("CEther Tests", async function () {
    it("Should mint", async function () {
      await cEther.connect(user1).mint({ value: ethers.utils.parseEther("1") });

      const exchangeRate = await cToken.exchangeRateStored();
      console.log(
        "🚀 ~ file: Compound.test.ts ~ line 53 ~ exchangeRate",
        exchangeRate
      );

      const balance = await cEther.balanceOf(user1.address);
      console.log("🚀 ~ file: Compound.test.ts ~ line 53 ~ balance", balance);
    });
  });

  describe("Comptroller Tests", async function () {
    // it("Should run", async function () {});
  });

  describe("cToken Tests", async function () {
    // it("Should run", async function () {
    //   const exchangeRate = await cToken.exchangeRateStored();
    //   console.log(
    //     "🚀 ~ file: Compound.test.ts ~ line 18 ~ it ~ exchangeRate",
    //     exchangeRate / 1e18
    //   );
    //   const cash = await cToken.getCash();
    //   console.log("🚀 ~ file: Compound.test.ts ~ line 24 ~ cash", cash / 1e8);
    // });
  });
});
