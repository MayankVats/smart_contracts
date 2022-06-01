import { expect } from "chai";
import { ethers } from "hardhat";
import { RapidIceCreams } from "../src/types/contracts/OBAC.sol";

describe("Owner Based Access Control", () => {
  let Instance;
  let obac: RapidIceCreams;

  beforeEach(async function () {
    Instance = await ethers.getContractFactory(
      "contracts/OBAC.sol:RapidIceCreams"
    );
    obac = (await Instance.deploy()) as RapidIceCreams;
  });

  describe("OBAC Tests", function () {
    it("Should open shop", async function () {
      await obac.openShop();
    });

    it("Should fail to open the shop - (Already Opened)", async function () {
      await obac.openShop();
      await expect(obac.openShop()).to.be.revertedWith("shop already opened");
    });
  });
});
