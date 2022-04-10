import { parseEther } from "ethers/lib/utils";
import { ethers } from "hardhat";
import { OrangeToken__factory } from "../typechain-types/factories/OrangeToken__factory";

async function main() {
  const name = 'Orange Token';
  const symbol = 'ORT';
  const decimals = 18;
  const totalSupply = '1000000000'

  const OrangeToken = await ethers.getContractFactory("OrangeToken") as OrangeToken__factory;
  const orangeToken = await OrangeToken.deploy(name, symbol, decimals, totalSupply);

  await orangeToken.deployed();

  console.log("OrangeToken deployed to:", orangeToken.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
