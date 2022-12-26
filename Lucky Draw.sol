// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5 <0.9;

contract LuckyDraw {
    
    address public Manager;
    address payable[] public participants;

    constructor () {
        Manager = msg.sender;
    }
    receive() external payable{
        require(msg.value==1 ether);
        participants.push(payable(msg.sender));
    }

    function GetBalance ()public view returns (uint) {
        require(msg.sender==Manager, "You are not a Manager");
        return address(this).balance;
    }

    function SelectRandom() public view returns (uint){
        return uint (keccak256(abi.encodePacked(block.difficulty, block.timestamp, participants.length)));
    }

    function SelectWinner () public{
        require (msg.sender==Manager);
        require (participants.length>=3);
        uint r=SelectRandom();
        address payable Winner;
        uint index = r % participants.length;
        Winner = participants[index];
        Winner.transfer(GetBalance());
        participants=new address payable[] (0);
    }
}