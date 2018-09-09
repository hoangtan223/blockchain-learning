pragma solidity ^0.4.0;

contract Voting {
    uint maxId = 0;
    struct candidate {
        string name;
        uint votes;
    }

    mapping (uint => candidate) candidates;
    mapping (address => bool) votedList;

    modifier validId(uint candidateId) {
        require(candidateId > 0 && candidateId <= maxId, "Candidate Id is invalid");
        _;
    }

    modifier canVote() {
        require(votedList[msg.sender] == false, "Already voted");
        _;
    }

    function addCandidate(string name) public returns(uint) {
        maxId++;
        candidates[maxId].name = name;
        return maxId;
    }

    function getCandidateNameById(uint id) public view validId(id) returns(string) {
        return candidates[id].name;
    }

    function votForCandidate(uint id) public validId(id) canVote validId(id) returns(uint) {
        votedList[msg.sender] = true;
        return ++candidates[id].votes;
    }

    function getVoteOfCandidate(uint id) public view validId(id) returns(uint) {
        return candidates[id].votes;
    }

    function getWinner() public view returns(uint) {
        uint winnerId = 0;
        for(uint i = 1; i <= maxId; i++) {
            if (candidates[i].votes > candidates[winnerId].votes) {
                winnerId = i;
            }
        }
        return winnerId;
    }
}