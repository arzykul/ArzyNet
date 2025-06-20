// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ARZY-G Token Prototype — Token Born From Usefulness, Not Mining
contract ARZYG {
    address public reserve; // Резервный кошелёк — родительский токен

    mapping(address => uint256) public bornTokens;
    mapping(address => string[]) public workHistory;

    event TokenBorn(address indexed user, uint256 amount, string reason);

    constructor(address _reserve) {
        reserve = _reserve;
    }

    function birthToken(address to, uint256 amount, string memory reason) public {
        require(msg.sender == reserve, "Only reserve authority can birth tokens");
        bornTokens[to] += amount;
        workHistory[to].push(reason);
        emit TokenBorn(to, amount, reason);
    }

    function getUsefulnessScore(address user) public view returns (uint256) {
        return bornTokens[user];
    }

    function getWorkHistory(address user) public view returns (string[] memory) {
        return workHistory[user];
    }
}