// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CharityDonation {
    address payable public contractOwner;
    mapping(address => uint) public donations;
    mapping(address => bool) public charities;
    mapping(uint => address) private lutcharities;
    mapping(address => bool) public Donors;
    mapping(uint => address) private lutDonors;
    mapping(address => uint) public totalDonationsByDonor;
    mapping(address => uint) public totalDonationsByCharity;
    uint public numberOfDonors;
    uint public numberOfCharities;

    constructor() {
        contractOwner = payable(msg.sender); 
    }

    function transferOwnership(address newOwner) external {
        require(msg.sender == contractOwner, "Only the contract owner can change the contract owner.");
        contractOwner = payable(newOwner);
    }

    // function addCharity(address _charity) public returns(address[] memory){
    //     require(msg.sender == contractOwner, "Only the contract owner can add charities.");
    //     address[] memory _charit_y = new address[](1);
    //     charities[_charity] = true;
    //     _charit_y[1]=_charity;
    //     return _charit_y;
    // }

    function addCharity(address _charity) public {
        require(msg.sender == contractOwner, "Only the contract owner can add charities.");
        charities[_charity] = true;
        uint charitiesIndex = numberOfCharities++;
        lutcharities[charitiesIndex]=_charity;
    }

    function getAllCharities() public view returns(address[] memory) {
        address[] memory _Charities = new address[](numberOfCharities);
        for(uint i=0; i<numberOfCharities; i++){
            _Charities[i]=lutcharities[i];
        }
        return _Charities;
    }
    
    function getAllDonors() public view returns(address[] memory) {
        address[] memory _Donors = new address[](numberOfDonors);
        for(uint i=0; i<numberOfDonors; i++){
            _Donors[i]=lutDonors[i];
        }
        return _Donors;
    }


    function donate(address _charity) public payable {
        require(charities[_charity], "Invalid charity address.");
        require(msg.value > 0, "Donation amount must be greater than 0.");
        uint matchedAmount = msg.value;
        if (contractOwner.balance >= msg.value) {
            contractOwner.transfer(msg.value);
        } else {
            matchedAmount = contractOwner.balance;
            contractOwner.transfer(matchedAmount);
        }
        if (!Donors[msg.sender]){
            uint fundersIndex = numberOfDonors++;
            Donors[msg.sender]=true;
            lutDonors[fundersIndex]=msg.sender;
        }
        donations[_charity] += msg.value + matchedAmount;
        totalDonationsByDonor[msg.sender] += msg.value; // בדיקה לגבי האם התורם  קיים, צריך לבדוק מה קורה עם תורם חדש? האם הוא נוסף לרשימה?
        totalDonationsByCharity[_charity] += msg.value + matchedAmount;
    }


    function withdraw() public {
        uint amount = donations[msg.sender];
        require(amount > 0, "No funds available for withdrawal.");
        donations[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }

//     function getAllDonorsAndDonations() public view returns (address[] memory, uint256[] memory) {
//     address[] memory donorAddresses = new address[](totalDonationsByDonor.length);
//     uint256[] memory donorDonations = new uint256[](totalDonationsByDonor.length);
//     uint256 i = 0;
//     for (address donorAddress ; totalDonationsByDonor) {
//         donorAddresses[i] = donorAddress;
//         donorDonations[i] = totalDonationsByDonor[donorAddress];
//         i++;
//     }
//     return (donorAddresses, donorDonations);
// }


    // function autoMatchDonation() public payable {
    //     require(msg.sender == contractOwner, "Only the contract owner can auto-match donations.");
    // }
}
