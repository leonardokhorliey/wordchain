// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract WordChainAdmin is Ownable {

    mapping (address => bool) public admins;
    address[] public addedAdmins;

    event AddAdmin(address indexed);
    event RemoveAdmin(address indexed);

     /**
     * @dev Function to add an array of addresses to tournament admins
     *
     * @param addresses_    Addresses array to whitelist
     */
    function whiteListAdmins(address[] memory addresses_) public onlyOwner {
        for (uint i=0; i < addresses_.length; i++) {
            if (admins[addresses_[i]]) {continue;}
            admins[addresses_[i]] = true;
            emit AddAdmin(addresses_[i]);
        }
    }


    function removeAdmin(address addr) public onlyOwner {
        for (uint i = 0; i < addedAdmins.length; i++) {
            if (addedAdmins[i] == addr) {
                addedAdmins[i] = addedAdmins[addedAdmins.length - 1];
                addedAdmins.pop();
                break;
            }
        }
        emit RemoveAdmin(addr);
    }

}