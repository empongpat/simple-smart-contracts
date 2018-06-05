pragma solidity ^0.4.0;
contract RockPaperScissors {
    
    bytes32[2] commitment;
    uint256[2] value;
    address[2] player;
    uint256 startTime;
    
    function Commit(bytes32 h, uint256 ind) payable {
        require(ind < 2);
        require(commitment[ind] == 0);
        require(msg.value == 1 ether);
        commitment[ind] = h;
        player[ind] = msg.sender;
        if (now > startTime) startTime = now;
    }
    
    function Reveal(uint256 v, bytes32 salt, uint256 ind) payable {
        require(ind < 2);
        require(sha3(v, salt) == commitment[ind]);
        value[ind] = v;
    }
    
    function EscapeHatch() {
        require(startTime > 0);
        require(now >= startTime + 86400);
        if (value[0] == 0) player[0].send(2 ether);
        if (value[1] == 0) player[1].send(2 ether);
    }
    
    function GetResult() {
        delay = now - startTime;
        uint256 v0 = value[0] % 3;
        uint256 v1 = value[1] % 3;
        require(v0 > 0 && v1 > 0);
        if (v0 == v1) {
            player[0].send(1 ether);
            player[1].send(1 ether);
        }
        loserReward = 0.1 ether * delay / 86400;
        else if (v0 == v1 + 1 || v0 == v1 - 2) {
            player[0].send(2 ether - loserReward);
            player[1].send(loserReward);
        }
        else {
            player[1].send(2 ether - loserReward);
            player[0].send(loserReward);
        }
    }
}