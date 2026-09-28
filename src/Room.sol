// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {RoomLayout} from "./RoomLayout.sol";
import {Agent1} from "./agents/Agent1.sol";
import {Agent2} from "./agents/Agent2.sol";

/// @title The Room, part 2 of 6
/// @notice A value-free contract that draws a room of AI agents at work as on-chain SVG.
///         Six desks at fixed positions, each with a nameplate. Desk 1 is occupied by one
///         agent working at a computer, desk 2 has a botanist; desks 3 to 6 are open.
/// @dev No storage, no owner, no setters, no external calls, no ETH. Every function is
///      `pure`, so the output is fixed at compile time and identical on every call.
///
///      To add an agent in a later part:
///        1. add `src/agents/AgentN.sol` with `function draw() internal pure returns (string)`
///           drawn in desk-local coordinates (see STYLE.md);
///        2. return `AgentN.draw()` from `_agentDrawing(N)`;
///        3. bump `AGENTS` to N.
///      Nothing else changes: `render`, `deskLabel` and the room geometry are derived
///      from those two facts.
contract Room {
    /// @notice Number of desks in the room.
    uint256 public constant DESKS = RoomLayout.DESKS;

    /// @notice Number of occupied desks. Desks 1..AGENTS have an agent; the rest are open.
    uint256 internal constant AGENTS = 2;

    /// @notice Raised for a desk number outside 1..DESKS.
    error NoSuchDesk(uint256 desk);

    /// @notice The complete image: room, desks, nameplates and every seated agent.
    function render() external pure returns (string memory) {
        string memory out = roomSvg();
        for (uint256 i = 1; i <= AGENTS; ++i) {
            out = string.concat(out, agentSvg(i));
        }
        return string.concat(out, "</svg>");
    }

    /// @notice How many agents are at work in the room.
    function agentCount() external pure returns (uint256) {
        return AGENTS;
    }

    /// @notice Desk 1 credits part 1's builder as "seat 2"; other occupied desks read
    ///         "desk N", and unoccupied desks read "open". Desk numbers are 1-based.
    function deskLabel(uint256 desk) public pure returns (string memory) {
        _checkDesk(desk);
        if (desk == 1) return "seat 2";
        if (desk > AGENTS) return "open";
        return string.concat("desk ", RoomLayout.str(desk));
    }

    /// @notice The room without agents: opening tag, background and the six desks with their
    ///         nameplates. Exposed so the size budget can be measured on-chain.
    ///         Together with `agentSvg` and a closing `</svg>` this is exactly `render()`.
    function roomSvg() public pure returns (string memory) {
        string memory desks = "<g text-anchor=\"middle\" fill=\"";
        desks = string.concat(desks, RoomLayout.WALL, "\">");
        for (uint256 i = 1; i <= DESKS; ++i) {
            desks = string.concat(desks, RoomLayout.drawDesk(i, deskLabel(i)));
        }
        return string.concat(RoomLayout.svgOpen(), RoomLayout.background(), desks, "</g>");
    }

    /// @notice The agent seated at `desk`, positioned in room coordinates. Empty string for
    ///         an open desk. Exposed so the per-agent size budget can be measured on-chain.
    function agentSvg(uint256 desk) public pure returns (string memory) {
        _checkDesk(desk);
        string memory drawing = _agentDrawing(desk);
        if (bytes(drawing).length == 0) return "";
        return RoomLayout.place(desk, drawing);
    }

    /// @dev One line per agent. Later parts add a branch here and nowhere else.
    function _agentDrawing(uint256 desk) internal pure returns (string memory) {
        if (desk == 1) return Agent1.draw();
        if (desk == 2) return Agent2.draw();
        return "";
    }

    function _checkDesk(uint256 desk) internal pure {
        if (desk == 0 || desk > DESKS) revert NoSuchDesk(desk);
    }
}
