// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import { ERC20 } from "solmate/tokens/ERC20.sol";

contract MockERC20 is ERC20 {
    uint8 public constant DECMIMALS = 18;

    constructor() ERC20("Mock Token", "MCT", DECMIMALS) {}

    function mint(address _to, uint256 _amount) external {
        _mint(_to, _amount);
    }
}
