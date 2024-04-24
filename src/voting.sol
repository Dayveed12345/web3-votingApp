// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Voting {
    error Unauthorized();
    error YouCantVoteTwice();

    address public immutable owner;
    address public currentUser;

    struct Details {
        string name;
        address addr;
    }

    mapping(address => uint256) public voteCount;
    mapping(address => bool) public HasVoted;
    mapping(address => Details) public candidateDetails;
    address[] public allAddresses;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized");
        _;
    }

    modifier addressExists(address _addr) {
        require(checkAddressExist(_addr), "Address does not exist");
        _;
    }

    modifier addressNotExists(address _addr) {
        require(checkAddressExist(_addr) == false, "Address already exist!!");
        _;
    }

    function checkAddressExist(address _addr) public view returns (bool) {
        for (uint256 i = 0; i < allAddresses.length; i++) {
            if (allAddresses[i] == _addr) {
                return true;
            }
        }
        return false;
    }

    function registerCandidate(string memory name, address addr)
        public
        onlyOwner
        addressNotExists(addr)
        returns (bool)
    {
        candidateDetails[addr] = Details(name, addr);
        allAddresses.push(addr);
        return true;
    }

    function getVotesCount(address addr) public view returns (uint256) {
        return voteCount[addr];
    }

    function castYourVotes(address addr) public addressExists(addr) {
        currentUser = msg.sender;
        require(HasVoted[currentUser] == false, "You can only vote once");

        HasVoted[currentUser] = true;
        voteCount[addr]++;
    }

    function GetHasVoted() public view returns (bool) {
        return HasVoted[currentUser];
    }

    function displayCandidates() public view returns (address[] memory) {
        return allAddresses;
    }

    function displaySpecificCandidate(address addr) public view returns (string memory, address, uint256) {
        Details memory detail = candidateDetails[addr];
        return (detail.name, detail.addr, voteCount[addr]);
    }

    function getWinner() public view returns (string memory, address, uint256) {
        uint256 maxVotes = 0;
        address winnerAddress;
        for (uint256 i = 0; i < allAddresses.length; i++) {
            address candidateAddr = allAddresses[i];

            if (voteCount[candidateAddr] > maxVotes) {
                maxVotes = voteCount[candidateAddr];
                winnerAddress = candidateAddr;
            }
        }
        Details memory detail = candidateDetails[winnerAddress];
        return (detail.name, detail.addr, voteCount[winnerAddress]);
    }
}
