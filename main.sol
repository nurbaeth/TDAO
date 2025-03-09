// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ThanosDAO {
    struct Proposal {
        string description;
        uint256 voteCount;
        bool executed;
    }

    address public owner;
    Proposal[] public proposals;
    mapping(address => bool) public hasVoted;

    event ProposalCreated(uint256 indexed proposalId, string description);
    event Voted(uint256 indexed proposalId, address indexed voter);
    event ProposalExecuted(uint256 indexed proposalId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createProposal(string memory _description) external onlyOwner {
        proposals.push(Proposal({description: _description, voteCount: 0, executed: false}));
        emit ProposalCreated(proposals.length - 1, _description);
    }

    function vote(uint256 _proposalId) external {
        require(_proposalId < proposals.length, "Proposal does not exist");
        require(!hasVoted[msg.sender], "You have already voted");
        require(!proposals[_proposalId].executed, "Proposal already executed");
        
        proposals[_proposalId].voteCount++;
        hasVoted[msg.sender] = true;
        emit Voted(_proposalId, msg.sender);
    }

    function executeProposal(uint256 _proposalId) external onlyOwner {
        require(_proposalId < proposals.length, "Proposal does not exist");
        require(!proposals[_proposalId].executed, "Proposal already executed");
        require(proposals[_proposalId].voteCount > 0, "Not enough votes");
        
        proposals[_proposalId].executed = true;
        emit ProposalExecuted(_proposalId);
    }
}
