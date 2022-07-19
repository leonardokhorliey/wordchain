// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

struct Player {
        uint256 id;
        address add_;
        string username;
        uint8 score;
        uint256 gamesPlayed;
        bool blacklisted;
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
    uint256 minimumStakeAmount;
    uint256 totalStake;
    bool isPrivate;
    uint256 createdAt;
    address owner;
    string tournamentKey;
}

struct UserTournament {
    uint256[] tournamentsOwned;
    uint256[] tournamentsJoined;
}