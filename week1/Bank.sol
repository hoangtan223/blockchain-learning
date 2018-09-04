pragma solidity ^0.4.0;

interface iBank{
    function deposit(address accountId) payable external;
}

contract Bank is iBank {

    uint currentSavingId = 0;
    struct saving {
        uint amount;
        uint months;
        address accountOwnerId;
    }
    struct account{
        uint amount;
        string name;
    }
    mapping (address => account) accounts;
    mapping (uint => saving) savings;

    uint constant interest1Mo = 4;
    uint constant interest2Mo = 5;
    uint constant interest3Mo = 6;
    string constant bankName = "Travis first bank";

    function depositToMyAccount() payable public {
        accounts[msg.sender].amount = accounts[msg.sender].amount + msg.value;
    }

    function deposit(address accountId) payable external {
        accounts[accountId].amount += msg.value;
    }

    function checkMyBalance() view public returns (uint) {
        return accounts[msg.sender].amount;
    }

    function withdrawFromMyAccount(uint amount) public {
        require(accounts[msg.sender].amount > amount);
        accounts[msg.sender].amount -= amount;

        msg.sender.transfer(amount);
    }


    function setMyName(string accountName) public {
        require(bytes(accountName).length <= 64);
        accounts[msg.sender].name = accountName;
    }

    function getName() view public returns (string) {
        return accounts[msg.sender].name;
    }

    function openSaving(uint amount, uint months) public {
        require(accounts[msg.sender].amount > amount);
        accounts[msg.sender].amount -= amount;
        uint savingId = currentSavingId++;
        savings[savingId].accountOwnerId = msg.sender;
        savings[savingId].amount = amount;
        savings[savingId].months = months;
    }

    function calculateInterestAfter(uint id, uint months) view public returns (uint) {
        require(months > 0);

        uint interest = 0;

        if (months == 1) interest = 4;
        else if (months == 2) interest = 5;
        else interest = interest3Mo;

        return (savings[id].amount * interest/100/12) * months;
    }

    function closeSavingAccountAfter(uint id, uint months) public {
        require(savings[id].accountOwnerId == msg.sender);
        accounts[msg.sender].amount += savings[id].amount + calculateInterestAfter(id, months);
        savings[id].amount = 0;
    }

    function checkSaving(uint id) public view returns (uint, uint, address) {
        return (savings[id].amount, savings[id].months, savings[id].accountOwnerId);
    }

    function getBankName() public pure returns (string) {
        return bankName;
    }

    function transferToOtherBank(address bankAddress, address accountAddress) payable public {
        iBank otherBank = iBank(bankAddress);
        otherBank.deposit(accountAddress);
    }
}