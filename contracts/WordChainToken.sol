// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WordChainToken is ERC20, Ownable {

    address private stakeManager;

    constructor() ERC20("WordChainToken", "WCT") {
        _mint(msg.sender, 100000 * 10**decimals());
        stakeManager = msg.sender;
    }

    function increaseSupply(address owner, uint amount) public onlyOwner {
        _mint(msg.sender, amount * 10**decimals());
    }


}