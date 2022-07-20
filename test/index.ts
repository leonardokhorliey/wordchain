import { Contract } from "@ethersproject/contracts";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers, waffle } from "hardhat";


let owner: SignerWithAddress;
let wordChainToken: Contract; 

let stakeManager: Contract;

describe("WordChainToken deploy", function () {
  
  it("Should deploy the contract and mint 10000000 tokens to deployer", async function () {
    owner = (await ethers.getSigners())[0];
    const WordChainToken = await ethers.getContractFactory("WordChainToken");
    wordChainToken = await WordChainToken.deploy();
    await wordChainToken.deployed();

    const ownerBalance = await wordChainToken.balanceOf(owner.address);
    const supply = await wordChainToken.totalSupply();

    expect(ownerBalance).to.equal(ethers.utils.parseEther("100000000").toString());

    expect(supply).to.equal(ethers.utils.parseEther("100000000").toString());
    
  });

});


describe("WordChainToken increaseSupply()", function () {
  it("Should increase total supply", async () => {

    await wordChainToken.increaseSupply(100);

    const ownerBalance = await wordChainToken.balanceOf(owner.address);
    const supply = await wordChainToken.totalSupply();

    expect(ownerBalance).to.equal(ethers.utils.parseEther("100000100").toString());

    expect(supply).to.equal(ethers.utils.parseEther("100000100").toString());
  });
});

describe("TokenManager deploy", function () {

  it("Should deploy contract and intitalize state variables", async () => {
    const TokenManager = await ethers.getContractFactory("TokenManager");
    stakeManager = await TokenManager.deploy(wordChainToken.address);

    await stakeManager.deployed();

    expect(await stakeManager.tokensPerEth()).to.equal(20);
    expect(await stakeManager.owner()).to.equal(owner.address);
  })

  it("Should allow purchase of tokens and increase balance", async function () {
    // transfer all minted tokens on deployment to stake manager;
    await wordChainToken.transfer(stakeManager.address, ethers.utils.parseEther("100000100"));
    expect(await wordChainToken.balanceOf(owner.address)).to.equal(0);
    expect(await wordChainToken.balanceOf(stakeManager.address)).to.equal(ethers.utils.parseEther("100000100"));

    const provider = waffle.provider;
    const signerEthBalance = await provider.getBalance(owner.address);
    const contractBalance = await provider.getBalance(stakeManager.address);
    const buyTrans = await stakeManager.buyTokens({value: ethers.utils.parseEther("2")});

    console.log(buyTrans.gasUsed);

    const finalSignerBalance = await provider.getBalance(owner.address);
    const finalContractBalance = await provider.getBalance(stakeManager.address);
    const expectedTokenTransfer = 2* await stakeManager.tokensPerEth();

    expect(await wordChainToken.balanceOf(owner.address)).to.equal(ethers.utils.parseEther(expectedTokenTransfer.toString()));
    expect(await wordChainToken.balanceOf(stakeManager.address)).to.equal(ethers.utils.parseEther((100000100 - expectedTokenTransfer).toString()));


    // expect(Number(ethers.utils.formatEther(signerEthBalance)) - 2).to.equal(Number(ethers.utils.formatEther(finalSignerBalance)));
    // expect(Number(ethers.utils.formatEther(contractBalance)) + 2).to.equal(Number(ethers.utils.formatEther(finalContractBalance)));
  })

  it("Should allow purchase")
});




