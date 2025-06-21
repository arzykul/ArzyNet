// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ARZYG is ERC20 {
    address public reserve;
    mapping(address => string[]) public workHistory;

    event TokenBorn(address indexed to, uint256 amount, string reason);

    constructor(address _reserve) ERC20("ARZY-G", "ARZYG") {
        reserve = _reserve;
    }

    function birthToken(address to, uint256 amount, string memory reason) public {
        require(msg.sender == reserve, "Only reserve authority can birth tokens");
        _mint(to, amount);
        workHistory[to].push(reason);
        emit TokenBorn(to, amount, reason);
    }

    function getWorkHistory(address user) public view returns (string[] memory) {
        return workHistory[user];
    }
}
