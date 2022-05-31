/**
 * @type import('hardhat/config').HardhatUserConfig
 */
require("@nomiclabs/hardhat-waffle");
const dotenv = require("dotenv");
dotenv.config();

module.exports = {
  solidity: "0.8.4",
  networks: {
    hardhat: {
      forking: { url: process.env.MAINNET_API, blockNumber: 14877894 },
    },
  },
  paths: {
    sources: "./contracts/",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts",
  },
};
