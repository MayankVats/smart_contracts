const BankContractInfo = require("../abis/Bank");
const TokenContractInfo = require("../abis/Token");
const TestTokenContractInfo = require("../abis/TestToken");

const ethers = require("ethers");
const { hexZeroPad } = require("ethers/lib/utils");

const provider = new ethers.providers.JsonRpcProvider(
  "https://speedy-nodes-nyc.moralis.io/b1fc98a2012a977c3a266576/bsc/mainnet"
);

const EOA = "0xe81db2B45cf9C1A93a32A29c5bBC177B028Bfa6e";
const CA = "0xC7D39CBa625486e4628B76c331f6492A67029add";

async function providerTest() {
  // get balance of an address
  const balance = await provider.getBalance(EOA);
  console.log(ethers.utils.formatEther(balance));

  // check whether the address have any code stored
  // EOA
  let code = await provider.getCode(EOA);
  console.log(code);
  // Contract Address
  code = await provider.getCode(CA);
  // console.log(code);

  // check number of transactions of an address
  // used in calculating nonce
  const transactionCount = await provider.getTransactionCount(EOA);
  console.log("transactionCount", transactionCount);

  // get the latest blocknumber that is mined.
  const latesBlock = await provider.getBlockNumber();
  console.log("latesBlock: ", latesBlock);

  // get info about the latest block
  const latestBlockInfo = await provider.getBlock(latesBlock);
  console.log("latestBlockInfo: ", latestBlockInfo);

  // get the network Info
  const networkInfo = await provider.getNetwork();
  console.log("networkInfo: ", networkInfo);

  // get gas price of the network.
  const gasPrice = await provider.getGasPrice();
  console.log("gasPrice: ", ethers.utils.formatUnits(gasPrice, "gwei"));

  // get the feeData
  const feeData = await provider.getFeeData();
  console.log("feeData: ", feeData);

  // get the transaction using transaction hash
  const txn = await provider.getTransaction(
    "0xe738b21a4cf76c343dcd6a7561376c09f2063348482633dad94210dbcaed4cb9"
  );
  console.log("txn: ", txn);

  // get the transaction receipt using the transaction hash.
  const txnReceipt = await provider.getTransactionReceipt(
    "0xab746ee990f6b45a9b88ec106fad9f608199ba1d00d94c18eaaf1b2423a135fe"
  );
  console.log("txnReceipt: ", txnReceipt);
}

async function interfaceTest() {
  const FormatTypes = ethers.utils.FormatTypes;

  const iface = new ethers.utils.Interface(TokenContractInfo.abi);

  console.log(iface.format(FormatTypes.full));
  console.log(iface.format(FormatTypes.minimal));

  console.log(
    iface.encodeFunctionData("transferFrom", [
      "0x8ba1f109551bD432803012645Ac136ddd64DBA72",
      "0xaB7C8803962c0f2F5BBBe3FA8bf41cd82AA1923C",
      ethers.utils.parseEther("1.0"),
    ])
  );
}

async function contractTest() {
  // In case we create the provider without using the MetaMask
  // we have create the Wallet's instance
  // which will be passed into the Contract's constructor
  // thus successfully sending the write transactions.

  const wallet = new ethers.Wallet(
    "caa856cf86bbedc3e9a0be54448a4e3a962bd6fb365f7ca1eb7f61ef0f71741d",
    provider
  );

  const TestToken = new ethers.Contract(
    TestTokenContractInfo.address,
    TestTokenContractInfo.abi,
    wallet
  );

  const totalSupply = await TestToken.totalSupply();
  console.log(ethers.utils.formatEther(totalSupply));

  const balance = await TestToken.balanceOf(EOA);
  console.log(ethers.utils.formatEther(balance));

  let txn;
  try {
    txn = await TestToken.mint(EOA, ethers.utils.parseEther("1.0"));
    console.log(
      "🚀 ~ file: etherjs_tutorial.js ~ line 109 ~ contractTest ~ txn",
      txn
    );
  } catch (err) {
    console.log(err);
  }

  try {
    txn = await TestToken.transferFrom(
      "0x2E3c462e0884855650fDd8d44EA8fE7C097BaF9C",
      "0x1A92CC5F41CfDBe0C153C901b782eBDe2e14c52f",
      ethers.utils.parseEther("1.0")
    );
    console.log(
      "🚀 ~ file: etherjs_tutorial.js ~ line 123 ~ contractTest ~ txn",
      txn
    );
  } catch ({ error }) {
    console.log(
      "🚀 ~ file: etherjs_tutorial.js ~ line 128 ~ contractTest ~ error",
      error
    );

    // const body = JSON.parse(error.error.body);
    // console.log(body.error.message);
  }
}

async function addressTest() {
  const address = ethers.utils.getAddress(
    "0x1A92CC5F41CfDBe0C153C901b782eBDe2e14c52f"
  );

  console.log(address);

  console.log(
    ethers.utils.isAddress("0x1A92CC5F41CfDBe0C153C901b782eBDe2e14c52f")
  );
}

async function eventTest() {
  const filter = {
    address: TestTokenContractInfo.address,
    topics: [
      ethers.utils.id("Transfer(address,address,uint256)"),
      null,
      hexZeroPad(EOA, 32),
    ],
  };

  console.log(filter);

  provider.on(filter, (result) => {
    console.log(result);
  });
  provider.on(
    { address: "0xe81db2b45cf9c1a93a32a29c5bbc177b028bfa6e" },
    (result) => {
      console.log(result);
    }
  );
}

async function transactionTest() {
  const wallet = new ethers.Wallet(
    "caa856cf86bbedc3e9a0be54448a4e3a962bd6fb365f7ca1eb7f61ef0f71741d",
    provider
  );

  const TestToken = new ethers.Contract(
    TestTokenContractInfo.address,
    TestTokenContractInfo.abi,
    wallet
  );

  let unsignedTxn = await TestToken.populateTransaction.mint(
    EOA,
    ethers.utils.parseEther("1.0")
  );
  console.log(
    "🚀 ~ file: etherjs_tutorial.js ~ line 183 ~ transactionTest ~ txn",
    unsignedTxn
  );

  const signedTransaction = await wallet.signTransaction(unsignedTxn);
  console.log(
    "🚀 ~ file: etherjs_tutorial.js ~ line 194 ~ transactionTest ~ signedTransaction",
    signedTransaction
  );

  // const transaction = await wallet.sendTransaction(unsignedTxn);
  // console.log(
  //   "🚀 ~ file: etherjs_tutorial.js ~ line 200 ~ transactionTest ~ transaction",
  //   transaction
  // );
}

async function stringTest() {
  const bytes32Message = ethers.utils.formatBytes32String("hello");
  console.log(
    "🚀 ~ file: etherjs_tutorial.js ~ line 209 ~ stringTest ~ bytes32Message",
    bytes32Message
  );

  const originalMessage = ethers.utils.parseBytes32String(bytes32Message);
  console.log(
    "🚀 ~ file: etherjs_tutorial.js ~ line 215 ~ stringTest ~ originalMessage",
    originalMessage
  );
}

providerTest();
// contractTest();
// eventTest();
// addressTest();
// transactionTest();
// stringTest();
