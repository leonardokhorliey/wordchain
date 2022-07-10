// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import './WordChainToken.sol';

contract TokenManager is Ownable {

    address private _owner;
    WordChainToken private wcToken;
    uint8 public constant tokensPerEth = 20;

    address[] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => uint) stakersArrayIndexes;

    event BuyTokens(address indexed, uint256, uint256);

    constructor (address WCToken) {
        _owner = msg.sender;
        wcToken = WordChainToken(WCToken);
        wcToken._mint(address(this), 20000);
    }

    function buyTokens() public payable {
        uint256 tokenAmount = msg.value * tokensPerEth;
        wcToken.transfer(msg.sender, tokenAmount);
    }

    function modifyTokenBuyPrice(uint newPrice) public onlyOwner {
        tokenBuyPrice = newPrice;
    }

    function stakeToken(uint numOfTokens) public {
        require(numOfTokens > 0, 'Supply value less than zero');
        uint8 dec = bubToken._decimals();
        uint lowestForm = numOfTokens * 10 ** dec;
        require(lowestForm <= bubToken.balanceOf(msg.sender), 'Not enough tokens');
        bubToken.approve(msg.sender, numOfTokens * 10 ** dec);
        bubToken.transferFrom(msg.sender, address(this), numOfTokens * 10 ** dec);
        stakingBalance[msg.sender] += numOfTokens * 10 ** dec;
        if (!hasStaked[msg.sender]) {
            stakersArrayIndexes[msg.sender] = stakers.length;
            stakers.push(msg.sender);
            hasStaked[msg.sender] = true;
        }
    }

    function unstakeToken(uint numOfTokens) public {
        uint8 dec = bubToken._decimals();
        uint lowestForm = numOfTokens * 10 ** dec;
        require(lowestForm <= stakingBalance[msg.sender], "You haven't staked up to this amount before.");
        bubToken.transfer(msg.sender, lowestForm);
        stakingBalance[msg.sender] -= lowestForm;
        if (stakingBalance[msg.sender] == 0) {
            removeElementfromStakers(stakersArrayIndexes[msg.sender]);
            hasStaked[msg.sender] = false;
        }
    }

    function claimRewards() public {
        require(stakingBalance[msg.sender] > 0, "You don't have token staked");
        stakingBalance[msg.sender] += stakingBalance[msg.sender] / 100;
    }

    function issueToken() public onlyOwner {
        for (uint i = 0; i < stakers.length; i++) {
            bubToken.transferFrom(address(_owner), stakers[i], stakingBalance[stakers[i]]);
        }
    }

    function getTokenBalance() public view returns (uint) {
        return bubToken.balanceOf(msg.sender);
    }

    function getAmountStaked() public view returns (uint) {
        return stakingBalance[msg.sender];
    }

    function transferTokens(address to, uint amount) public {
        uint8 dec = bubToken._decimals();
        uint lowestForm = amount * 10 ** dec;
        uint tokenBalance = getTokenBalance();
        require(lowestForm <= tokenBalance, "You don't have sufficient tokens");
        bubToken.approve(msg.sender, lowestForm);
        bubToken.transferFrom(msg.sender, to, lowestForm);
        
    }
}