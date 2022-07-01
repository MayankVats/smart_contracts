import { ethers, network } from "hardhat";
import {
  abi as routerABI,
  address as routerAddress,
} from "../abis/UniswapV2RouterMainnet";

import {
  abi as factoryABI,
  address as factoryAddress,
} from "../abis/UniswapV2FactoryMainnet";

import {
  abi as pairABI,
  address as pairAddress,
} from "../abis/UniswapV2PairMainnet";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

describe("Mainnet Test", () => {
  let router: any;
  let factory: any;
  let pair: any;
  let signer: SignerWithAddress;

  beforeEach(async function () {
    router = await ethers.getContractAt(routerABI, routerAddress);
    factory = await ethers.getContractAt(factoryABI, factoryAddress);
    pair = await ethers.getContractAt(pairABI, pairAddress);

    await network.provider.request({
      method: "hardhat_impersonateAccount",
      params: ["0xEA674fdDe714fd979de3EdF0F56AA9716B898ec8"],
    });

    signer = await ethers.getSigner(
      "0xEA674fdDe714fd979de3EdF0F56AA9716B898ec8"
    );

    const balance = await signer.getBalance();
    console.log("🚀 ~ file: UniswapV2.test.ts ~ line 39 ~ balance", balance);
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

  describe("Uniswap V2 - Pair", function () {
    it("Get Reserves", async function () {
      const reserves = await pair.getReserves();
      console.log(
        "🚀 ~ file: UniswapV2.test.js ~ line 59 ~ reserves",
        reserves["_reserve0"],
        reserves["_reserve1"]
      );
    });

    it("Get Quotes", async function () {
      const reserves = await pair.getReserves();

      const quote = await router.quote(
        ethers.utils.parseUnits("1", 6),
        reserves["_reserve0"],
        reserves["_reserve1"]
      );
      console.log("🚀 ~ file: UniswapV2.test.js ~ line 74 ~ quote", quote);
    });
  });
});
