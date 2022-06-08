import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { BigNumber, ContractFactory } from "ethers";
import { ethers } from "hardhat";
import { ERC20Permit, Vault } from "../src/types/contracts";

async function getPermitSignature(
  signer: SignerWithAddress,
  token: ERC20Permit,
  spender: String,
  value: Number,
  deadline: BigNumber
) {
  const [nonce, name, version, chainId] = await Promise.all([
    token.nonces(signer.address),
    token.name(),
    "1",
    signer.getChainId(),
  ]);

  return ethers.utils.splitSignature(
    await signer._signTypedData(
      {
        name,
        version,
        chainId,
        verifyingContract: token.address,
      },
      {
        Permit: [
          {
            name: "owner",
            type: "address",
          },
          {
            name: "spender",
            type: "address",
          },
          {
            name: "value",
            type: "uint256",
          },
          {
            name: "nonce",
            type: "uint256",
          },
          {
            name: "deadline",
            type: "uint256",
          },
        ],
      },
      {
        owner: signer.address,
        spender,
        value,
        nonce,
        deadline,
      }
    )
  );
}

describe("ERC20Permit Tests", function () {
  let Instance: ContractFactory;
  let Token: ERC20Permit;
  let Vault: Vault;

  let owner: SignerWithAddress;
  let signer: SignerWithAddress;
  let user: SignerWithAddress;

  let addrs: SignerWithAddress[];

  beforeEach(async function () {
    [owner, signer, user, ...addrs] = await ethers.getSigners();

    Instance = await ethers.getContractFactory("ERC20Permit");
    Token = (await Instance.deploy("Token Permit", "TKNP")) as ERC20Permit;

    Instance = await ethers.getContractFactory("Vault");
    Vault = (await Instance.deploy(Token.address)) as Vault;
  });

  describe("Testing", function () {
    it("ERC20 permit", async function () {
      const amount = 1000;
      await Token.mint(user.address, amount);

      const deadline = ethers.constants.MaxUint256;

      const { v, r, s } = await getPermitSignature(
        user,
        Token,
        Vault.address,
        amount,
        deadline
      );

      await Vault.connect(user).depositWithPermit(amount, deadline, v, r, s);
      expect(await Token.balanceOf(Vault.address)).to.equal(amount);
    });
  });
});
