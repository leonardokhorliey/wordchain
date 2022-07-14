// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './TokenManager.sol';

contract WordChain {

    TokenManager private stakeManager;

    struct Player {
        uint256 id;
        address add_;
        string username;
        uint8 score;
        uint256 gamesPlayed;
    }

    // enum TournamentStatus {
    //     PENDING,
    //     STARTED,
    //     ENDED
    // }

    struct Tournament {
        uint256 id;
        string name;
        string description;
        uint256 deadline;
        uint8 minimumStakeAmount;
        uint8 totalStake;
        bool isPrivate;
        uint256 createdAt;
        address owner;
        string tournamentKey;
    }

    mapping (uint256 => Player[]) tournamentPlayers;
    mapping (address => uint256[]) ownerTournaments;
    mapping (address => string) userNames;

    Tournament[] public tournaments;
    address[] public players;

    event CreateTournament(uint256 indexed, string, string, uint256, uint8, bool, uint256, address);
    event StartTournament(uint256 indexed, uint256);
    event JoinTournament(uint256 indexed, address);
    event CreateUser(address indexed, string);
    event DispatchReward(uint256 indexed, address, uint256);

    constructor (address tokenManager_) {
        stakeManager = TokenManager(tokenManager_);
    }

    modifier IsTournamentOwner(uint256 tournamentId) {
        require(msg.sender == tournaments[tournamentId].owner, "Not the owner of the tournament");
        _;
    }

    modifier TournamentExists(uint256 tournamentId) {
        require(tournamentId < tournaments.length, "Tournament does not exist");
        _;
    }

    function createTournament(string calldata name_, string calldata desc_, uint256 interval_, uint8 minimumStake_, bool isPrivate_, string calldata key) public {
        uint id_ = tournaments.length;
        tournaments.push({
            id: id_,
            name: name_,
            description: desc_,
            deadline: block.timestamp + (interval_ *24 *3600),
            minimumStakeAmount: minimumStake_,
            totalStake: 0,
            isPrivate: isPrivate_,
            createdAt: block.timestamp,
            owner: msg.sender,
            tournamentKey: key
        });
        ownerTournaments[msg.sender].push(id_);
        tournamentPlayers[id_] = [msg.sender];
        emit CreateTournament(id_, name_, desc_, block.timestamp + (interval_ *24 *3600), minimumStake_, isPrivate_, block.timestamp, msg.sender);
    }


    function getTournaments() public view returns (Tournament[] memory) {
        return tournaments;
    }

    function getTournamentbyId(uint256 id_) public view returns (Tournament memory) {
        return tournaments[id_];
    }

    function getOwnerTournaments(address add_) public view returns (Tournament[] memory) {
        Tournament[] tournaments_ = [];
        uint256[] tournamentIds = ownerTournaments[address];
        for (uint256 i = 0; i < tournamentIds.length; i++) {
            tournaments_.push(tournaments[tournamentIds[i]]);
        }

        return tournaments_;
    }

    function checkIfUsernameExists(string memory username_) public view returns (bool) {
        for (uint i = 0; i < players.length; i++) {
            if (keccak256(abi.encodePacked(userNames(players[i]))) == keccak256(abi.encodePacked(username_))) {
                return true;
            }
            
        }
        return false;
    }

    function createUser(string memory username_) public {
        require (checkIfUsernameExists(username_), "The username you entered is already taken");
        players.push(msg.sender);
        userNames(msg.sender) = username_;

        emit CreateUser(msg.sender, username_);
    }

    function joinTournament(uint256 tournamentId_, string memory key_) public {
        Tournament memory tournament = tournaments[tournamentId_];
        require (keccak256(abi.encodePacked(key_)) == keccak256(abi.encodePacked(tournament.tournamentKey)), "Invalid Tournament Key");

        uint stakeAmount = stakeManager.getAmountStaked(key_, msg.sender);
        require (stakeAmount >= tournament.minimumStakeAmount, "You have not staked sufficient to join this tournament");
        require (checkIfUserIsATournamentPlayer(tournamentId_, msg.sender) < 0, "You are already a part of this tournament");

        uint256 id_ = tournamentPlayers(tournamentId_).length;
        tournamentPlayers(tournamentId_).push({
            id: id_,
            add_: msg.sender,
            username: userNames(msg.sender),
            score: 0,
            gamesPlayed: 0
        });
        tournament.totalStake += stakeAmount;

        emit JoinTournament(tournamentId_, msg.sender);
    }

    function checkIfUserIsATournamentPlayer(uint256 tournamentId_, address user) public TournamentExists(tournamentId_) view returns (int) {
        Player[] memory players = tournamentPlayers[tournamentId_];
        for (uint i = 0; i < players.length; i++) {
            if (players[i].add_ == user) {
                return i;
            }
            
        }
        return -1;
    }

    function checkIfUserIsAStakingPlayer(uint256 tournamentId_, address user) public TournamentExists(tournamentId_) view returns (bool) {
        require (checkIfUserIsATournamentPlayer(tournamentId_, msg.sender) >= 0);
        Tournament memory tournament = tournaments[tournamentId_];
        if (stakeManager.getAmountStaked(tournament.tournamentKey, msg.sender) >= tournament.minimumStakeAmount) {return true;}
        return false;
    }

    function dispatchRewards(uint256 tournamentId_, address first, address second, address third) public TournamentExists(tournamentId_) {
        require (block.timestamp > tournaments[tournamentId_].deadline, "Rewards can only be sent at the end of a Tournament");
        require (checkIfUserIsATournamentPlayer(tournamentId_, first) >= 0 && checkIfUserIsATournamentPlayer(tournamentId_, second) >= 0 && 
        checkIfUserIsATournamentPlayer(tournamentId_, third) >= 0, "One or more of these addresses are not on this tournament");

        uint8 totalStake = tournaments[tournamentId_].totalStake;

        stakeManager.transferTokens(first, totalStake * 5 / 10);
        stakeManager.transferTokens(second, totalStake * 3 / 10);
        stakeManager.transferTokens(third, totalStake * 2 / 10);

        emit DispatchReward(tournamentId_, first, totalStake * 5 / 10);
        emit DispatchReward(tournamentId_, second, totalStake * 3 / 10);
        emit DispatchReward(tournamentId_, third, totalStake * 2 / 10);

    }

    function sendScore(uint256 tournamentId_, uint8 score, uint256 playerTournamentId) public TournamentExists(tournamentId_) {
        require (block.timestamp <= deadline, "Can only set score during tournament");
        require (score < 7, "Score sent is beyond threshold.");
        require (playerTournamentId < tournamentPlayers[tournamentId_].length, "Player Id sent does not exist for the tournament sent");
        tournamentPlayers[tournamentId_][playerTournamentId].score += score;
        tournamentPlayers[tournamentId_][playerTournamentId].gamesPlayed += 1;
    }

    // function renewTournament(uint256 tournamentId_) public TournamentExists(tournamentId_) {
    //     require();
    // }


}