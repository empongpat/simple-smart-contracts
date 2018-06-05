pragma solidity ^0.4.0;

contract BidirectionalChannel {
    
    address[2] players;
    uint256 seq;
    uint256 withdrawer;
    uint256 withdrawalTime;
    uint256 value;
    
    function setPlayers(address player2) {
        require(players[0] == 0 && players[1] == 0);
        players[0] = msg.sender;
        players[1] = player2;
    }
    
    function StartWithdraw(uint256 index, uint256 _seq, uint256 _value, 
            uint256 v, uint256 r, uint256 s) {
        require(msg.sender == players[index]);
        require(index < 2);
        require(ecrecover(sha3(_seq, value), v, r, s) == players[1 - index]);
        if (seq > 0) {
            require(seq > _seq);
            require(index != withdrawer);
            players[index].send(_value);
            players[1 - index].send(this.balance);
        }
        else {
            require(withdrawalTime == 0);
            withdrawer = index;
            seq = _seq;
            value = _value;
            withdrawalTime = now + 86400;
        }
    }
    
    function FinalizeWithdrawal() {
        require(now >= withdrawalTime);
        players[withdrawer].send(value);
        players[1 - withdrawer].send(this.balance);
    }
}