const { ethers } = require("hardhat");
const {
  abi: routerABI,
  address: routerAddress,
} = require("../abis/UniswapV2RouterMainnet");

const {
  abi: factoryABI,
  address: factoryAddress,
} = require("../abis/UniswapV2FactoryMainnet");

describe("Mainnet Test", () => {
  let router;
  let factory;

  beforeEach(async function () {
    router = await ethers.getContractAt(routerABI, routerAddress);
    factory = await ethers.getContractAt(factoryABI, factoryAddress);
  });

  describe("Uniswap V2 - Router", function () {
    it("Gets factory address", async function () {
      let factoryAddress = await router.factory();
      console.log(
        "🚀 ~ file: UniswapV2.test.js ~ line 14 ~ factoryAddress",
        factoryAddress
      );
    });

    it("Gets WETH address", async function () {
      let wethAddress = await router.WETH();
      console.log(
        "🚀 ~ file: UniswapV2.test.js ~ line 22 ~ it ~ wethAddress",
        wethAddress
      );
    });
  });

  describe("Uniswap V2 - Factory", function () {
    it("Gets Pair for token addresses", async function () {
      const pair = await factory.getPair(
        "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48",
        "0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2"
      );
      console.log("🚀 ~ file: UniswapV2.test.js ~ line 42 ~ it ~ pair", pair);
    });
  });

  describe("Uniswap V2 - Pair", function () {});
});
