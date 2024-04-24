// SPDX-License-Identifier: SMIT
pragma solidity ^0.8.25;

import {Test, console} from "forge-std/Test.sol";
import {Voting} from "../src/voting.sol";

//Dont forget to inherit or what is wrong with you;

contract VotingTest is Test {
    Voting public voting;
    uint256 number = 1;

    // address[] public  allAddresses;

    function setUp() public {
        voting = new Voting();

        //    allAddresses().push(address(2));
    }

    function testRegisterCandidate() public {
        vm.prank(address(this));
        bool success = voting.registerCandidate("David", address(1));
        assertEq(success, true);
    }

    function testOnlyOwnerCanAddCandidate() public {
        vm.expectRevert();
        vm.prank(address(1));
        voting.registerCandidate("david", address(1));
    }

    function testCastYourVotes() public {
        vm.prank(address(this));
        voting.registerCandidate("david", address(2));
        vm.prank(msg.sender);
        voting.castYourVotes(address(2));
        bool success = voting.GetHasVoted();
        uint256 count = voting.getVotesCount(address(2));
        assertEq(success, true);
        assertEq(count, 1);
    }

    // function testCantVoteTwice() public {
    //       vm.expectRevert();
    //     vm.prank(address(this));
    //     voting.registerCandidate("david", address(2));
    //     vm.prank(address(1));
    //      console.log(voting.GetHasVoted());
    //     voting.castYourVotes(address(2));
    //     voting.castYourVotes(address(2));
    // }

    function testAddressNotFound() public {
        vm.expectRevert();
        vm.prank(msg.sender);
        voting.castYourVotes(address(2));
    }

    function testdisplayCandidates() public {
        vm.prank(address(this));
        voting.registerCandidate("david", address(2));
        address[] memory addr = voting.displayCandidates();
        assertEq(addr.length, 1);
    }

    function testDisplaySpecificCandidate() public {
        vm.prank(address(this));
        voting.registerCandidate("david", address(2));
        (string memory name, address addr, uint256 voteCount) = voting.displaySpecificCandidate(address(2));
        assertEq(name, "david");
        assertEq(addr, address(2));
        assertEq(voteCount, 0);
    }

    function testgetWinner() public {
        vm.prank(address(this));
        voting.registerCandidate("david", address(1));
        vm.prank(address(3));
        voting.castYourVotes(address(1));
        vm.prank(address(4));
        voting.castYourVotes(address(1));
        (string memory name, address addr, uint256 count) = voting.getWinner();
        assertEq(name, "david");
        assertEq(addr, address(1));
        assertEq(count, 2);
    }
}
