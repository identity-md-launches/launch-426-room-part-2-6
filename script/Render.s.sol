// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {Room} from "../src/Room.sol";

/// @notice Offline renderer for the SVG snapshot check. No broadcast or filesystem cheatcodes.
contract Render {
    function run() external returns (string memory svg) {
        return new Room().render();
    }
}
