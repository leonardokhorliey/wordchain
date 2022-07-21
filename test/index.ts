import { Contract } from "@ethersproject/contracts";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";
import { expect } from "chai";
import { ethers, waffle } from "hardhat";


let owner: SignerWithAddress;
let secondAddress: SignerWithAddress;
let wordChainToken: Contract; 
let admin: Contract; 
let wordChain: Contract; 
let stakeManager: Contract;
const assumedTournamentKey = 'WordXXyyyy';
const provider = waffle.provider;

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

    expect(await stakeManager.tokensPerEth()).to.equal(200);
    expect(await stakeManager.owner()).to.equal(owner.address);
  })

  it("Should allow purchase of tokens and increase balance", async function () {
    // transfer all minted tokens on deployment to stake manager;
    await wordChainToken.transfer(stakeManager.address, ethers.utils.parseEther("100000100"));
    expect(await wordChainToken.balanceOf(owner.address)).to.equal(0);
    expect(await wordChainToken.balanceOf(stakeManager.address)).to.equal(ethers.utils.parseEther("100000100"));

    
    const signerEthBalance = await provider.getBalance(owner.address);
    const contractBalance = await provider.getBalance(stakeManager.address);
    const buyTrans = await stakeManager.buyTokens({value: ethers.utils.parseEther("2")});


    const finalSignerBalance = await provider.getBalance(owner.address);
    const finalContractBalance = await provider.getBalance(stakeManager.address);
    const expectedTokenTransfer = 2* await stakeManager.tokensPerEth();

    expect(await wordChainToken.balanceOf(owner.address)).to.equal(ethers.utils.parseEther(expectedTokenTransfer.toString()));
    expect(await wordChainToken.balanceOf(stakeManager.address)).to.equal(ethers.utils.parseEther((100000100 - expectedTokenTransfer).toString()));


    // expect(Number(ethers.utils.formatEther(signerEthBalance)) - 2).to.equal(Number(ethers.utils.formatEther(finalSignerBalance)));
    // expect(Number(ethers.utils.formatEther(contractBalance)) + 2).to.equal(Number(ethers.utils.formatEther(finalContractBalance)));
  })

  it("Should allow staking tokens for a tournament and reduce user token balance", async() => {
    const signerInitialBalance = await wordChainToken.balanceOf(owner.address);
    await wordChainToken.approve(stakeManager.address, ethers.utils.parseEther("1"));
    await stakeManager.stakeToken(1, assumedTournamentKey);
    const balanceAfterStake = await wordChainToken.balanceOf(owner.address);
    expect(Number(ethers.utils.formatEther(signerInitialBalance)) - 1).to.equal(Number(ethers.utils.formatEther(balanceAfterStake)));
    expect(await stakeManager.stakingBalance(assumedTournamentKey, owner.address)).to.equal(ethers.utils.parseEther("1"));
  })

  it("Should let user withdraw tokens", async () => {
    const signerInitialBalance = await wordChainToken.balanceOf(owner.address);
    const signerEthBalance = await provider.getBalance(owner.address);
    await wordChainToken.approve(stakeManager.address, ethers.utils.parseEther("3"));
    await stakeManager.withdrawTokens(3);
    const balanceAfterWithdraw = await wordChainToken.balanceOf(owner.address);
    const finalSignerBalance = await provider.getBalance(owner.address);

    expect(Number(ethers.utils.formatEther(signerInitialBalance)) - 3).to.equal(Number(ethers.utils.formatEther(balanceAfterWithdraw)));
    expect(Number(ethers.utils.formatEther(signerEthBalance)) + (3/200)).greaterThanOrEqual(Number(ethers.utils.formatEther(finalSignerBalance)));
  });

  it("Should transfer tokens to an address", async() => {
    secondAddress = (await ethers.getSigners())[1];
    const userInitialBalance = await wordChainToken.balanceOf(secondAddress.address);
    await stakeManager.transferTokens(secondAddress.address, 5); 
    const finalBalance = await wordChainToken.balanceOf(secondAddress.address);

    expect(Number(ethers.utils.formatEther(userInitialBalance)) + 5).to.equal(Number(ethers.utils.formatEther(finalBalance)));

  });

  it("Should set user staking balance", async () => {
    const initialStake = await stakeManager.stakingBalance(assumedTournamentKey, secondAddress.address);
    await stakeManager.setUserStakingBalance(secondAddress.address, assumedTournamentKey, 10);
    const finalStake = await stakeManager.stakingBalance(assumedTournamentKey, secondAddress.address);

    expect(Number(ethers.utils.formatEther(initialStake)) + 10).to.equal(Number(ethers.utils.formatEther(finalStake)));
    
  })
});

describe("WordChainAdmin", function() {
  it("Should deploy and set deployer as admin", async () => {
    const Admin = await ethers.getContractFactory("WordChainAdmin");
    admin = await Admin.deploy();

    await admin.deployed();
    const adminsSet = await admin.addedAdmins(0);

    expect(adminsSet).to.equal(owner.address);
    expect(await admin.admins(owner.address)).true;
  })

  it("Should whitelist admins", async () => {
    let toAdd = (await ethers.getSigners()).slice(1,3);
    let toAddAddresses = toAdd.map((ele)=> ele.address);

    await admin.whiteListAdmins(toAddAddresses);
    const secondAdmin = await admin.addedAdmins(1);
    const thirdAdmin = await admin.addedAdmins(2);

    expect(secondAdmin).to.equal(toAddAddresses[0]);
    expect(thirdAdmin).to.equal(toAddAddresses[1]);
    expect(await admin.admins(toAddAddresses[0])).true;
  })

  it("Should get all admins", async () => {
    const adminsSet = await admin.getAllAdmins();

    expect(adminsSet.length).to.equal(3);
  })

  it("Should remove admins", async () => {
    let toRemove = await admin.addedAdmins(1);
    await admin.removeAdmin(toRemove);
    const isRemoved = !(await admin.getAllAdmins()).includes(toRemove);
    expect((await admin.getAllAdmins()).length).to.equal(2);
    expect(isRemoved).true;
  })
})


describe("WordChain", function () {

  it("Should deploy contract and set state variables", async () => {
    const WordChain = await ethers.getContractFactory("WordChain");
    wordChain = await WordChain.deploy(stakeManager.address, admin.address);

    await wordChain.deployed();

    const stakeManager_ = await wordChain.stakeManager();
    expect(stakeManager_.address).to.equal(stakeManager_.address);

  })

  // it("Should create tournament ")
})




