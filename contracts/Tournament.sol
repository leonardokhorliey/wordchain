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

    TokenManager public stakeManager;
    WordChainAdmin private adminManager;

    mapping (uint256 => Player[]) public tournamentPlayers;
    mapping (address => uint256[]) public ownedTournaments;
    mapping (address => uint256[]) public joinedTournaments;
    mapping (address => string) public userNames;
    mapping (address => bool) public blackList;

    Tournament[] public tournaments;
    address[] public users;

    event CreateTournament(uint256 indexed tournamentId, string name, string description, uint256 deadline, uint8 minimumStake, bool isPrivate, string tournamentKey, uint256 startDate, address owner);
    event JoinTournament(uint256 indexed tournamentId, address userAddress);
    event CreateUser(address indexed userAddress, string userName);
    event DispatchReward(uint256 indexed transactionId, address userAddress, uint256 numberOfTokens);
    event BlackList(address indexed user);
    

    constructor (address payable tokenManager_, address admin_) {
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
            tournamentKey: key,
            numberOfParticipants: adminManager.admins(msg.sender) ? 0 : 1,
            isAdminCreated: adminManager.admins(msg.sender) ? true : false
        });
        tournaments.push(newTournament);
        ownedTournaments[msg.sender].push(id_);
        if (!adminManager.admins(msg.sender)) {
            joinedTournaments[msg.sender].push(id_);
            
            tournamentPlayers[id_].push(Player({
                id: 0,
                add_: msg.sender,
                username: userNames[msg.sender],
                score: 0,
                gamesPlayed: 0
            }));
        }
        
        emit CreateTournament(id_, name_, desc_, block.timestamp + (interval_ *60), minimumStake_, isPrivate_, key, block.timestamp, msg.sender);
    }


    function getAllTournaments() public view returns (Tournament[] memory) {
        return tournaments;
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
        return getTourmanentsWithIds(ownedTournaments[add_]);
    }

    function getTournamentsJoined(address add_) public view returns (Tournament[] memory) {
        return getTourmanentsWithIds(joinedTournaments[add_]);
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
        require(!adminManager.admins(msg.sender), "An admin can not join a tournament");
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
            gamesPlayed: 0
        }));
        tournaments[tournamentId_].totalStake += stakeAmount;
        tournaments[tournamentId_].numberOfParticipants += 1;
        joinedTournaments[msg.sender].push(tournamentId_);

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
        require (!blackList[first] && !blackList[second] && !blackList[third], "One or more of these addresses are blacklisted");

        uint256 totalStake = tournaments[tournamentId_].totalStake;

        stakeManager.transferTokens(first, totalStake * 4 / 10);
        stakeManager.transferTokens(second, totalStake * 2 / 10);
        stakeManager.transferTokens(third, totalStake * 1 / 10);

        emit DispatchReward(tournamentId_, first, totalStake * 4 / 10);
        emit DispatchReward(tournamentId_, second, totalStake * 2 / 10);
        emit DispatchReward(tournamentId_, third, totalStake * 1 / 10);
        tournaments[tournamentId_].totalStake = 0;
    }

    function sendScore(uint256 tournamentId_, uint8 score, uint256 playerTournamentId) public TournamentExists(tournamentId_) isNotBlacklisted(msg.sender) {
        require (block.timestamp <= tournaments[tournamentId_].deadline, "Can only set score during tournament");
        require (score < 7, "Score sent is beyond threshold.");
        require (checkIfUserIsATournamentPlayer(tournamentId_, msg.sender) >= 0, "You are not a member of this tournament.");
        tournamentPlayers[tournamentId_][playerTournamentId].score += score;
        tournamentPlayers[tournamentId_][playerTournamentId].gamesPlayed += 1;
    }

    // function renewTournament(uint256 tournamentId_, uint256 interval_) public TournamentExists(tournamentId_) isAdmin(msg.sender) {
    //     require (block.timestamp > tournaments[tournamentId_].deadline, "Can only renew tournament after deadline.");
    //     require (tournaments[tournamentId_].totalStake == 0, "Attempting to renew tournament without dispatching rewards.");
    //     require(tournaments[tournamentId_].isAdminCreated, "You can not renew a tournament that was not Admin hosted.");

    //     Player[] memory players_ = tournamentPlayers[tournamentId_];
    //     string memory tournamentKey = tournaments[tournamentId_].tournamentKey;
    //     for (uint256 i= 0; i < players_.length; i++) {
    //         for (uint256 j = 0; j < joinedTournaments[players_[i].add_].length; j++) {
    //             if (joinedTournaments[players_[i].add_][j] == tournamentId_) {
    //                 joinedTournaments[players_[i].add_][j] = joinedTournaments[players_[i].add_][joinedTournaments[players_[i].add_].length - 1];
    //                 joinedTournaments[players_[i].add_].pop();
    //                 break;
    //             }
    //         }
    //         stakeManager.setUserStakingBalance(players_[i].add_, tournamentKey, 0);
    //     }
    //     delete tournamentPlayers[tournamentId_];
    //     tournaments[tournamentId_].deadline = block.timestamp + (interval_ *60);
    //     tournaments[tournamentId_].totalStake = 0;

    // }

    function blackListAddress(address addr) public isAdmin(msg.sender) {
        uint256[] memory ownedTournaments_ = ownedTournaments[addr];
        uint256[] memory joinedTournaments_ = joinedTournaments[addr];
        if (ownedTournaments_.length > 0) {
            for (uint256 i = 0; i < ownedTournaments_.length; i++) {
                string memory key_ = tournaments[ownedTournaments_[i]].tournamentKey;
                uint256 stakeAmount = stakeManager.getAmountStaked(key_, addr);
                stakeManager.setUserStakingBalance(addr, key_, 0);
                tournaments[ownedTournaments_[i]].totalStake -= stakeAmount;
                
            }
            
        }

        if (joinedTournaments_.length > 0) {
            for (uint256 i = 0; i < joinedTournaments_.length; i++) {
                string memory key_ = tournaments[joinedTournaments_[i]].tournamentKey;
                uint256 stakeAmount = stakeManager.getAmountStaked(key_, addr);
                stakeManager.setUserStakingBalance(addr, key_, 0);
                tournaments[joinedTournaments_[i]].totalStake -= stakeAmount;
                
            }
            
        }
        blackList[addr] = true;
    }


}