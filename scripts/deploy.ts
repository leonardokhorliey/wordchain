// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from "hardhat";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const WordChainToken = await ethers.getContractFactory("WordChainToken");
  const wordChainToken = await WordChainToken.deploy();

  await wordChainToken.deployed();

  console.log("Greeter deployed to:", wordChainToken.address);

  const StakeManager = await ethers.getContractFactory("TokenManager");
  const stakeManager = await StakeManager.deploy(wordChainToken.address);

  await stakeManager.deployed();

  console.log("Greeter deployed to:", stakeManager.address);

  const WordChain = await ethers.getContractFactory("WordChain");
  const wordChain = await WordChain.deploy(stakeManager.address);

  await wordChain.deployed();

  console.log("Greeter deployed to:", wordChain.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
