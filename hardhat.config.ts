import { HardhatUserConfig } from "hardhat/config";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "solidity-coverage";
import { config as dotEnvConfig } from "dotenv";
dotEnvConfig();

const config: HardhatUserConfig = {
  solidity: "0.8.4",
  defaultNetwork: "localhost",
  networks: {
    hardhat: {
      // forking: { url: process.env.MAINNET_API || "", blockNumber: 14877894 },
      loggingEnabled: true,
    },
  },
  paths: {
    sources: "./contracts/",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
  typechain: {
    outDir: "src/types",
  },
};

export default config;
