// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CharityDonation {
    address payable public contractOwner;
    mapping(address => uint256) public donations;
    mapping(address => bool) public charities;
    mapping(address => uint256) public totalDonationsByDonor;
    mapping(address => uint256) public totalDonationsByCharity;

    constructor() {
        contractOwner = payable(msg.sender); 
    }

    function transferOwnership(address newOwner) external {
        require(msg.sender == contractOwner, "Only the contract owner can change the contract owner.");
        contractOwner = payable(newOwner);
    }

    function addCharity(address _charity) public {
        require(msg.sender == contractOwner, "Only the contract owner can add charities.");
        charities[_charity] = true;
    }

    function donate(address _charity) public payable {
        require(charities[_charity], "Invalid charity address.");
        require(msg.value > 0, "Donation amount must be greater than 0.");
        uint256 matchedAmount = msg.value;
        if (contractOwner.balance >= msg.value) {
            contractOwner.transfer(msg.value);
        } else {
            matchedAmount = contractOwner.balance;
            contractOwner.transfer(matchedAmount);
        }
        donations[_charity] += msg.value + matchedAmount;
        totalDonationsByDonor[msg.sender] += msg.value;
        totalDonationsByCharity[_charity] += msg.value + matchedAmount;
    }


    function withdraw() public {
        uint256 amount = donations[msg.sender];
        require(amount > 0, "No funds available for withdrawal.");
        donations[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }


    // function autoMatchDonation() public payable {
    //     require(msg.sender == contractOwner, "Only the contract owner can auto-match donations.");
    // }
}
