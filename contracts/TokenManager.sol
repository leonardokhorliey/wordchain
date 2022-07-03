// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './WordChainToken.sol';

contract TokenManager {

    WordChainToken private wcToken;

    constructor (string WCToken) {
        wcToken = WordChainToken(WCToken);
    }
}