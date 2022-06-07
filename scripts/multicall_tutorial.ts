import { BigNumber, ethers } from "ethers";
import { bytecode } from "../abis/MultiTokenBalanceGetter";

const provider = new ethers.providers.JsonRpcProvider(
  "https://speedy-nodes-nyc.moralis.io/b1fc98a2012a977c3a266576/bsc/testnet"
);

interface TokenBalances {
  [key: string]: BigNumber;
}

async function getBalances(tokens: string[], account: string) {
  const abiCoder = new ethers.utils.AbiCoder();

  // Encoding the constructor arguments
  const inputData = abiCoder.encode(
    ["address[]", "address"],
    [tokens, account]
  );

  // The constructor input is concatanated at the end of the contracts bytecode before deployment.
  // Here, we are adding the encoded constructor parameter values to the end of the bytecode of the contract.
  const fullData = bytecode.concat(
    // removing 0x from starting
    inputData.slice(2)
  );

  // Here we are making an eth_call with "data"
  // eth_call, instead of writing to the blockchain just executes the contract.
  const encodedReturnData = await provider.call({ data: fullData });

  const [_, decodedReturnData] = abiCoder.decode(
    ["uint256", "uint256[]"],
    encodedReturnData
  );

  const balances: TokenBalances = {};

  for (let i = 0; i < tokens.length; i++) {
    balances[tokens[i]] = decodedReturnData[i].toString();
  }

  return balances;
}

getBalances(
  [
    "0xeD24FC36d5Ee211Ea25A80239Fb8C4Cfd80f12Ee",
    "0x27F4b42B1476650e54e65bBF02AaEA3798744D26",
    "0x05925E171Ecd15cBd93E47Fd0C0D8Bd94aBAA89B",
    "0x393F4e3D0f50A6dEB3900842365AD896e0f99266",
    "0x2D0584167cfABdc9796E02eB7D46D3F8Ac3E7833",
  ],
  "0x2E3c462e0884855650fDd8d44EA8fE7C097BaF9C"
).then(console.log);
