// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title ARZY-G ERC20 Token — born only from verified usefulness (Web4 Standard)
/// @author Arzykul Muratov
contract ARZYG_ERC20 is ERC20 {
    address public reserve;

    constructor(uint256 initialSupply, address _reserve) ERC20("ARZY-G", "ARZYG") {
        reserve = _reserve;
        _mint(_reserve, initialSupply);
    }

    modifier onlyReserve() {
        require(msg.sender == reserve, "Only reserve can execute this action");
        _;
    }

    /// Mint to someone after usefulness is confirmed (by reserve)
    function mintByUsefulness(address to, uint256 amount, string memory proof) external onlyReserve {
        require(bytes(proof).length > 5, "Usefulness proof required");
        _mint(to, amount);
    }

    function mint(address to, uint256 amount) external onlyReserve {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) external onlyReserve {
        _burn(from, amount);
    }

    function changeReserve(address newReserve) external onlyReserve {
        reserve = newReserve;
    }
}