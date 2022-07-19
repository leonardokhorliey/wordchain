// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './TokenManager.sol';
import './WordChainAdmin.sol';
import {
    Player,
    Tournament,
    UserTournament
} from './TournamentStructs.sol';

contract WordChain {

    TokenManager private stakeManager;
    WordChainAdmin private adminManager;

    mapping (uint256 => Player[]) public tournamentPlayers;
    mapping (address => UserTournament) public ownerTournaments;
    mapping (address => string) public userNames;
    mapping (address => bool) public blackList;

    Tournament[] public tournaments;
    address[] public users;
    address[] public blacklistedAddresses;

    event CreateTournament(uint256 indexed, string, string, uint256, uint8, bool, uint256, address);
    event StartTournament(uint256 indexed, uint256);
    event JoinTournament(uint256 indexed, address);
    event CreateUser(address indexed, string);
    event DispatchReward(uint256 indexed, address, uint256);
    event TournamentOwnershipTransfer(uint256 indexed, address);
    event BlackListAddress(address indexed);

    constructor (address tokenManager_, address admin_) {
        stakeManager = TokenManager(tokenManager_);
        adminManager = WordChainAdmin(admin_);
    }

    modifier IsTournamentOwner(uint256 tournamentId) {
        require(msg.sender == tournaments[tournamentId].owner, "Not the owner of the tournament");
        _;
    }

    modifier TournamentExists(uint256 tournamentId) {
        require(tournamentId < tournaments.length, "Tournament does not exist");
        _;
    }

    modifier isAdmin(address addr) {
        require(adminManager.admins(addr), "Not an admin");
        _;
    }

    modifier isNotBlacklisted(address addr) {
        require(!blackList[addr], "User is blacklisted");
        _;
    }

     /**
     * @dev Public function to implement creation of a tournament by a user. Tournament can be public or private
     *
     * @param name_         The tournament name.
     * @param desc_         A brief description of the tournament.
     * @param interval_     How long in days should the tournament take.
     * @param minimumStake_ The minimum token amount to be staked to join the tournament.
     * @param isPrivate_    Boolean identifier for public or private tournament.
     * @param key           The identifier for a tournament.
     */
    function createTournament(string calldata name_, string calldata desc_, uint256 interval_, uint8 minimumStake_, bool isPrivate_, string calldata key) public isNotBlacklisted(msg.sender) {
        if (!adminManager.admins(msg.sender)) {
            require(stakeManager.getAmountStaked(key, msg.sender) >= minimumStake_ * 10 ** uint256(stakeManager.getTokenDecimals()), "You have not staked sufficient");
        }
        
        uint id_ = tournaments.length;
        Tournament memory newTournament = Tournament({
            id: id_,
            name: name_,
            description: desc_,
            deadline: block.timestamp + (interval_ *60),
            minimumStakeAmount: minimumStake_ * 10 ** uint256(stakeManager.getTokenDecimals()),
            totalStake: 0,
            isPrivate: isPrivate_,
            createdAt: block.timestamp,
            owner: msg.sender,
            tournamentKey: key
        });
        tournaments.push(newTournament);
        ownerTournaments[msg.sender].tournamentsOwned.push(id_);
        if (!adminManager.admins(msg.sender)) {
            ownerTournaments[msg.sender].tournamentsJoined.push(id_);
            // ownerTournaments[msg.sender].tournamentsOwned.push(id_);
            
            tournamentPlayers[id_].push(Player({
                id: 0,
                add_: msg.sender,
                username: userNames[msg.sender],
                score: 0,
                gamesPlayed: 0,
                blacklisted: false
            }));
        }
        
        emit CreateTournament(id_, name_, desc_, block.timestamp + (interval_ *60), minimumStake_, isPrivate_, block.timestamp, msg.sender);
    }


    /**
     * @dev                  Public function to retrieve some tournaments by their IDs.
     *
     * @param ids_           Tournament ID to search for.
     */
    function getTourmanentsWithIds(uint256[] memory ids_) private view returns (Tournament[] memory) {
        Tournament[] memory tournaments_ = new Tournament[](ids_.length);
        
        for (uint256 i = 0; i < ids_.length; i++) {
            tournaments_[i] = tournaments[ids_[i]];
        }

        return tournaments_;
    }

    function getTournamentsOwned(address add_) public view returns (Tournament[] memory) {
        return getTourmanentsWithIds(ownerTournaments[add_].tournamentsOwned);
    }

    function getTournamentsJoined(address add_) public view returns (Tournament[] memory) {
        return getTourmanentsWithIds(ownerTournaments[add_].tournamentsJoined);
    }



    function checkIfUsernameExists(string memory username_) public view returns (bool) {
        for (uint i = 0; i < users.length; i++) {
            if (keccak256(abi.encodePacked(userNames[users[i]])) == keccak256(abi.encodePacked(username_))) {
                return true;
            }
            
        }
        return false;
    }

    function createUser(string memory username_) public {
        require (!checkIfUsernameExists(username_), "The username you entered is already taken");
        users.push(msg.sender);
        userNames[msg.sender] = username_;

        emit CreateUser(msg.sender, username_);
    }

    function joinTournament(uint256 tournamentId_, string memory key_) public isNotBlacklisted(msg.sender) {
        
        if (tournaments[tournamentId_].isPrivate) {
            require (keccak256(abi.encodePacked(key_)) == keccak256(abi.encodePacked(tournaments[tournamentId_].tournamentKey)), "Invalid Tournament Key");
        }
        
        uint stakeAmount = stakeManager.getAmountStaked(key_, msg.sender);
        require (stakeAmount >= tournaments[tournamentId_].minimumStakeAmount, "You have not staked sufficient to join this tournament");
        require (checkIfUserIsATournamentPlayer(tournamentId_, msg.sender) < 0, "You are already a part of this tournament");

        uint256 id_ = tournamentPlayers[tournamentId_].length;
        tournamentPlayers[tournamentId_].push(Player({
            id: id_,
            add_: msg.sender,
            username: userNames[msg.sender],
            score: 0,
            gamesPlayed: 0,
            blacklisted: false
        }));
        tournaments[tournamentId_].totalStake += stakeAmount;
        ownerTournaments[msg.sender].tournamentsJoined.push(tournamentId_);

        emit JoinTournament(tournamentId_, msg.sender);
    }

    function getTournamentPlayers(uint256 tournamentId_) public view returns (Player[] memory) {
        return tournamentPlayers[tournamentId_];
    }

    function checkIfUserIsATournamentPlayer(uint256 tournamentId_, address user) public TournamentExists(tournamentId_) view returns (int) {
        for (uint i = 0; i < tournamentPlayers[tournamentId_].length; i++) {
            if (tournamentPlayers[tournamentId_][i].add_ == user) {
                return int256(i);
            }
            
        }
        return -1;
    }

    function checkIfUserIsAStakingPlayer(uint256 tournamentId_, address user) public TournamentExists(tournamentId_) view returns (bool) {
        require (checkIfUserIsATournamentPlayer(tournamentId_, user) >= 0);
        if (stakeManager.getAmountStaked(tournaments[tournamentId_].tournamentKey, user) >= tournaments[tournamentId_].minimumStakeAmount) {return true;}
        return false;
    }

    function dispatchRewards(uint256 tournamentId_, address first, address second, address third) public TournamentExists(tournamentId_) isAdmin(msg.sender) {
        require (block.timestamp > tournaments[tournamentId_].deadline, "Rewards can only be sent at the end of a Tournament");
        require (checkIfUserIsATournamentPlayer(tournamentId_, first) >= 0 && checkIfUserIsATournamentPlayer(tournamentId_, second) >= 0 && 
        checkIfUserIsATournamentPlayer(tournamentId_, third) >= 0, "One or more of these addresses are not on this tournament");

        uint256 totalStake = tournaments[tournamentId_].totalStake;

        stakeManager.transferTokens(first, totalStake * 4 / 10);
        stakeManager.transferTokens(second, totalStake * 2 / 10);
        stakeManager.transferTokens(third, totalStake * 1 / 10);

        emit DispatchReward(tournamentId_, first, totalStake * 4 / 10);
        emit DispatchReward(tournamentId_, second, totalStake * 2 / 10);
        emit DispatchReward(tournamentId_, third, totalStake * 1 / 10);

    }

    function sendScore(uint256 tournamentId_, uint8 score, uint256 playerTournamentId) public TournamentExists(tournamentId_) isNotBlacklisted(msg.sender) {
        require (block.timestamp <= tournaments[tournamentId_].deadline, "Can only set score during tournament");
        require (score < 7, "Score sent is beyond threshold.");
        require (playerTournamentId < tournamentPlayers[tournamentId_].length, "Player Id sent does not exist for the tournament sent");
        tournamentPlayers[tournamentId_][playerTournamentId].score += score;
        tournamentPlayers[tournamentId_][playerTournamentId].gamesPlayed += 1;
    }

    // function renewTournament(uint256 tournamentId_) public TournamentExists(tournamentId_) {
    //     require();
    // }
    function blackListAddress(address addr) public isAdmin(msg.sender) isNotBlacklisted(msg.sender) {
        uint256[] memory ownedTournaments = ownerTournaments[addr].tournamentsOwned;
        uint256[] memory joinedTournaments = ownerTournaments[addr].tournamentsOwned;
        if (ownedTournaments.length > 0) {
            for (uint256 i = 0; i < ownedTournaments.length; i++) {
                string memory key_ = tournaments[ownedTournaments[i]].tournamentKey;
                uint256 stakeAmount = stakeManager.getAmountStaked(key_, addr);
                stakeManager.setUserStakingBalance(addr, key_, 0);
                tournaments[ownedTournaments[i]].totalStake -= stakeAmount;
                bool transferOwnership = transferTournamentOwnership(tournaments[ownedTournaments[i]].id);
                if (!transferOwnership) {
                    closeTournament(tournaments[ownedTournaments[i]].id);
                }
            }
            
        }

        if (joinedTournaments.length > 0) {
            for (uint256 i = 0; i < joinedTournaments.length; i++) {
                string memory key_ = tournaments[joinedTournaments[i]].tournamentKey;
                uint256 stakeAmount = stakeManager.getAmountStaked(key_, addr);
                stakeManager.setUserStakingBalance(addr, key_, 0);
                tournaments[joinedTournaments[i]].totalStake -= stakeAmount;
                Player[] memory playersOfTournament = tournamentPlayers[joinedTournaments[i]];
                for (uint256 j = 0; j < playersOfTournament.length; j++) {
                    if (playersOfTournament[j].add_ == addr) {
                       tournamentPlayers[joinedTournaments[i]][j].blacklisted = true;
                       break;
                    }
                }
            }
            
        }
        
        blackList[addr] = true;
        blacklistedAddresses.push(addr);
        emit BlackListAddress(addr);
    }

    function transferTournamentOwnership(uint256 tournamentId_) private isAdmin(msg.sender) TournamentExists(tournamentId_) returns (bool) {
        address currentOwner = tournaments[tournamentId_].owner;
        Player[] memory playersOfTournament = tournamentPlayers[tournamentId_];
        uint256 loopCheckPoint = 0;
        for (uint256 i = 1; i < playersOfTournament.length; i++) {
            if (playersOfTournament[i - 1].add_ == currentOwner) {
                if (!playersOfTournament[i].blacklisted) {
                    tournaments[tournamentId_].owner = playersOfTournament[i].add_;
                    ownerTournaments[playersOfTournament[i].add_].tournamentsOwned.push(tournamentId_);
                    emit TournamentOwnershipTransfer(tournamentId_, tournaments[tournamentId_].owner);
                    return true;
                }
                loopCheckPoint = i - 1;
            }

            if (i > loopCheckPoint && !playersOfTournament[i].blacklisted) {
                tournaments[tournamentId_].owner = playersOfTournament[i].add_;
                ownerTournaments[playersOfTournament[i].add_].tournamentsOwned.push(tournamentId_);
                emit TournamentOwnershipTransfer(tournamentId_, tournaments[tournamentId_].owner);
                return true;
            }
        }

        return false;
    }

    function closeTournament(uint256 tournamentId_) public isAdmin(msg.sender) TournamentExists(tournamentId_) {
        require (block.timestamp > tournaments[tournamentId_].deadline, "Can only close tournament before deadline");
        Player[] memory playersOfTournament = tournamentPlayers[tournamentId_];
        for (uint256 i = 1; i < playersOfTournament.length; i++) {
            address user = playersOfTournament[i].add_;
            string memory key_ = tournaments[tournamentId_].tournamentKey;
            if (playersOfTournament[i].blacklisted) {
                continue;
            }
            refundTournamentPlayer(key_, user);

        }
        tournaments[tournamentId_].totalStake = 0;
        tournaments[tournamentId_].deadline = block.timestamp;
    }

    function refundTournamentPlayer(string memory key_, address addr) private {
        stakeManager.transferTokens(addr, stakeManager.getAmountStaked(key_, addr));
        stakeManager.setUserStakingBalance(addr, key_, 0);
    }
    
}