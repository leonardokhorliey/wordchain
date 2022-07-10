// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './TokenManager.sol';

contract WordChain {

    TokenManager private tokenManager;

    struct Player {
        address add_;
        uint256 score;
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
        bool isPrivate;
        uint256 createdAt;
        address owner;
        string tournamentKey
    }

    mapping (uint256 => Player[]) tournamentPlayers;
    mapping (address => uint256[]) ownerTournaments;

    Tournament[] public tournaments;

    event CreateTournament(uint256 indexed, string, string, uint256, uint8, bool, uint256, address);
    event StartTournament(uint256 indexed, uint256);

    constructor (address tokenManager_) {
        tokenManager = TokenManager(tokenManager_);
    }

    modifier isTournamentOwner(uint256 tournamentId) {
        require(msg.sender == tournaments[tournamentId].owner, "Not the owner of the tournament");
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
            isPrivate: isPrivate_,
            createdAt: block.timestamp,
            owner: msg.sender,
            tournamentKey: key
        });
        ownerTournaments[msg.sender].push(id_);
        tournamentPlayers[id_] = [msg.sender];
        emit CreateTournament(id_, name_, desc_, block.timestamp + (interval_ *24 *3600), minimumStake_, isPrivate_, block.timestamp, msg.sender);
    }

    // function whiteListParticipants(address[] memory contestants, uint256 tournamentId) public isTournamentOwner(tournamentId) {
    //     require(tournaments[tournamentId - 1].status == 0, "Tournament is already commenced");
    //     require(tournaments[tournamentId - 1].isPrivate, "Can only add participants to a private tournament");
        

    // }

    // function startTournament(uint256 tournamentId, uint256 interval_) public isTournamentOwner(tournamentId) {
    //     require(tournaments[tournamentId - 1].isPrivate, "Can only start a private tournament");
    // }

    function getTournaments() public view returns (Tournament[]) {
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

    function joinTournament()
}