// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract WordChainToken is ERC20 {

    string public constant name;
    string public constant symbol;


    constructor() ERC20("WordChainToken", "WCT") {
        _mint(address(this), 1000 * 10**decimals());
    }


}