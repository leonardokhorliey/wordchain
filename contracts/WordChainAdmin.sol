// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract WordChainAdmin is Ownable {

    mapping (address => bool) public admins;
    address[] public addedAdmins;

    event AddAdmin(address indexed address_);
    event RemoveAdmin(address indexed address_);



    constructor () {
        admins[msg.sender] = true;
        addedAdmins.push(msg.sender);
        emit AddAdmin(msg.sender);
    }

     /**
     * @dev Function to add an array of addresses to tournament admins
     *
     * @param addresses_    Addresses array to whitelist
     */
    function whiteListAdmins(address[] memory addresses_) public onlyOwner {
        for (uint i=0; i < addresses_.length; i++) {
            if (admins[addresses_[i]]) {continue;}
            addAnAdmin(addresses_[i]);
        }
    }

    function getAllAdmins() public view returns (address[] memory) {
        return addedAdmins;
    }

    function transferOwnership(address newOwner) public override onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        require(newOwner != owner(), "Trying to transfer ownership to owner");
        _transferOwnership(newOwner);
        addAnAdmin(newOwner);
    }

    function addAnAdmin(address addr) public onlyOwner {
        admins[addr] = true;
        addedAdmins.push(addr);
        emit AddAdmin(addr);
    }


    function removeAdmin(address addr) public onlyOwner {
        require(addr != owner(), "You can not remove contract owner from admins");
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