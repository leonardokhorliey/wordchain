// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import './WordChainToken.sol';

contract TokenManager is Ownable {

    address private _owner;
    WordChainToken public wcToken;
    uint8 public constant tokensPerEth = 20;

    address[] public stakers;
    mapping(string => mapping(address => uint)) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => uint) stakersArrayIndexes;

    event BuyTokens(address indexed, uint256, uint256);

    constructor (address WCToken) {
        _owner = msg.sender;
        wcToken = WordChainToken(WCToken);
    }

    function getETHBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function buyTokens() public payable {
        uint256 tokenAmount = msg.value * tokensPerEth;
        wcToken.transfer(msg.sender, tokenAmount);
    }

    // function modifyTokenBuyPrice(uint newPrice) public onlyOwner {
    //     tokensPerEth = newPrice;
    // }

    function stakeToken(uint numOfTokens, string memory tournamentKey) public {
        require(numOfTokens > 0, 'Supply value less than zero');
        uint8 dec = wcToken.decimals();
        uint lowestForm = numOfTokens * 10 ** dec;
        require(lowestForm <= wcToken.balanceOf(msg.sender), 'Not enough tokens');
        wcToken.transferFrom(msg.sender, address(this), lowestForm);
        stakingBalance[tournamentKey][msg.sender] += lowestForm;
        
    }

    // function issueToken(string memory tournamentKey, address user) public onlyOwner {
    //     wcToken.transfer(user, stakingBalance[tournamentKey][user]);
    // }

    function getTokenDecimals() public view returns (uint8) {
        return wcToken.decimals();
    }

    function getTokenBalance(address user) public view returns (uint) {
        return wcToken.balanceOf(user);
    }

    function getAmountStaked(string memory tournamentKey, address user) public view returns (uint) {
        return stakingBalance[tournamentKey][user];
    }

    function transferTokens(address to, uint amount) public onlyOwner {
        // if (getTokenBalance(address(this)) < amount *10 **wcToken.decimals()) {

        // }
        uint lowestForm = amount * 10 ** wcToken.decimals();
        wcToken.transfer(to, lowestForm);
        
    }

    function setUserStakingBalance(address addr, string memory tournamentKey, uint256 amount) public {
        stakingBalance[tournamentKey][addr] = amount;
    }
}