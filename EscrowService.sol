// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract EscrowService{
    address public buyer;
    address public seller;
    address public arbiter;

    uint public amount;
    bool public buyerConfirmed;
    bool public sellerConfirmed;
    bool public fundRelease;


    constructor (address _buyer, address _seller, address _arbiter) {
        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;
    }

    function deposite() public payable {
        require(buyer == msg.sender, "Only Buyer can deposite money");
        amount = msg.value;
    }

    function confirmTrade() public {
        if(msg.sender == buyer) {
            buyerConfirmed = true;
        }
        else if(msg.sender == seller) {
            sellerConfirmed= true;
        }
    }

    function arbitrateRefund() public {
        require(msg.sender == arbiter, " Only arbiter can send money to buyer.");
        payable (buyer).transfer(amount);
    }

    function arbitrateRelease() public {
        require(msg.sender == arbiter, "Only arbiter can send money to seller.");
        payable (seller).transfer(amount);
    }

    function releaseFund() public {
        require(msg.sender == seller, "Only seller can withdraw those money.");
        if(buyerConfirmed && sellerConfirmed) {
            payable (seller).transfer(amount);
            fundRelease = true;
        }
    }

    function getContractBalance() public view returns (uint){
            return address(this).balance;
    }
}