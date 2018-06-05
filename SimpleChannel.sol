pragma solidity ^0.4.0;

contract SimpleChannel {
    
    address p1;
    address p2;
    uint256 withdrawalTime;
    
    function setPlayers(address player2) {
        require(p2 == 0);
        p2 = player2;
        p1 = msg.sender;
    }
    
    function InitiatePlayer1Withdraw() {
        require(msg.sender == p1);
        withdrawalTime = now + 86400;
    }
    
    function FinalizePlayer1Withdraw() {
        require(withdrawalTime > 0);
        require(now >= withdrawalTime);
        p1.send(this.balance);
    }
    
    function Player2Withdraw(uint256 value, uint256 v, uint256 r, uint256 s) {
        require(msg.sender == p2);
        require(ecrecover(sha3(value), v, r, s) == p1);
        p2.send(value);
        p1.send(this.balance);
    }
}