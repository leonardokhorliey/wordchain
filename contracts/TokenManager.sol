// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import './WordChainToken.sol';

contract TokenManager is Ownable {

    address private _owner;
    WordChainToken public wcToken;
    uint256 public constant tokensPerEth = 500;

    address[] public stakers;
    mapping(string => mapping(address => uint)) public stakingBalance;

    event BuyTokens(address indexed buyer, uint256 ethSpent, uint256 tokenAmount);

    event WithdrawRequest(address requester, uint256 tokenAmount, uint256 ethAmount);
    event EthReceived(address from, uint256 value);

    constructor (address WCToken) {
        _owner = msg.sender;
        wcToken = WordChainToken(WCToken);
    }

    receive() external payable {
        emit EthReceived(msg.sender, msg.value);
    }

    fallback() external payable {
        emit EthReceived(msg.sender, msg.value);
    }

    function getETHBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function buyTokens() public payable {
        uint256 tokenAmount = msg.value * tokensPerEth;
        wcToken.transfer(msg.sender, tokenAmount);
        emit BuyTokens(msg.sender, msg.value, tokenAmount);
    }

    function withdrawTokens(uint256 amount) public payable returns (bool) {
        uint ethAmount = (amount * 10**wcToken.decimals())/tokensPerEth;
        if (getETHBalance() <= ethAmount) {
            return false;
        }
        
        wcToken.transferFrom(msg.sender, address(this), amount * 10**wcToken.decimals());
        (bool sent, ) = payable(msg.sender).call{value: ethAmount}("");
        require(sent, "Failed to send Ether");
        return true;
    }

    function stakeToken(uint numOfTokens, string memory tournamentKey) public {
        require(numOfTokens > 0, 'Supply value less than zero');
        uint lowestForm = numOfTokens * 10 ** wcToken.decimals();
        require(lowestForm <= wcToken.balanceOf(msg.sender), 'Not enough tokens');
        wcToken.transferFrom(msg.sender, address(this), lowestForm);
        stakingBalance[tournamentKey][msg.sender] += lowestForm;
        
    }


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
       
        uint lowestForm = amount * 10 ** wcToken.decimals();
        wcToken.transfer(to, lowestForm);
        
    }

    function setUserStakingBalance(address addr, string memory tournamentKey, uint256 amount) public onlyOwner {
        stakingBalance[tournamentKey][addr] = amount*10**wcToken.decimals();
    }

    function withdrawContractEth(uint256 weiAmount, address payable to) public onlyOwner returns (bool sent) {
        (sent, ) = to.call{value: weiAmount}("");
        require(sent, "Failed to send Ether");
    }
}