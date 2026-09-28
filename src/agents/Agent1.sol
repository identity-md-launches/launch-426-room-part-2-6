// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/// @title Agent1
/// @notice The first agent: a small robot seated at its computer, typing. Drawn in
///         desk-local coordinates (desk top-left corner is (0,0), y grows downward, the
///         agent sits to the left of the desk on negative x). See STYLE.md for the rules.
/// @dev Later parts add `Agent2.sol` ... `Agent6.sol` with the same `draw()` signature.
library Agent1 {
    string internal constant CHAIR = "#3d4460";
    string internal constant BODY = "#6d7fa3";
    string internal constant BODY_DARK = "#5b6f99";
    string internal constant SHELL = "#e6e9f0";
    string internal constant VISOR = "#35d0b5";
    string internal constant ACCENT = "#f5a860";
    string internal constant FRAME = "#30364a";
    string internal constant SCREEN = "#101522";

    /// @notice Chair, robot, keyboard, monitor with a blinking cursor, and a mug.
    function draw() internal pure returns (string memory) {
        return string.concat(_chair(), _robot(), _computer());
    }

    function _chair() private pure returns (string memory) {
        return string.concat(
            "<g fill=\"",
            CHAIR,
            "\"><rect x=\"-34\" y=\"-34\" width=\"6\" height=\"50\" rx=\"2\"/>",
            "<rect x=\"-32\" y=\"12\" width=\"30\" height=\"5\" rx=\"1\"/>",
            "<rect x=\"-19\" y=\"17\" width=\"4\" height=\"24\"/>",
            "<rect x=\"-30\" y=\"40\" width=\"26\" height=\"3\" rx=\"1\"/></g>"
        );
    }

    function _robot() private pure returns (string memory) {
        return string.concat(_body(), _head());
    }

    function _body() private pure returns (string memory) {
        return string.concat(
            "<rect x=\"-24\" y=\"4\" width=\"24\" height=\"8\" rx=\"3\" fill=\"",
            BODY_DARK,
            "\"/><rect x=\"-26\" y=\"-26\" width=\"18\" height=\"34\" rx=\"4\" fill=\"",
            BODY,
            "\"/><path d=\"M-14-16L6-4\" stroke=\"",
            BODY,
            "\" stroke-width=\"5\" stroke-linecap=\"round\"/>"
        );
    }

    function _head() private pure returns (string memory) {
        return string.concat(
            "<rect x=\"-28\" y=\"-50\" width=\"22\" height=\"20\" rx=\"5\" fill=\"",
            SHELL,
            "\"/><rect x=\"-20\" y=\"-44\" width=\"12\" height=\"6\" rx=\"2\" fill=\"",
            VISOR,
            "\"/><path d=\"M-17-50v-6\" stroke=\"",
            SHELL,
            "\" stroke-width=\"2\"/><circle cx=\"-17\" cy=\"-57.5\" r=\"2.5\" fill=\"",
            ACCENT,
            "\"/>"
        );
    }

    function _computer() private pure returns (string memory) {
        return string.concat(_monitor(), _deskItems());
    }

    function _monitor() private pure returns (string memory) {
        return string.concat(
            "<rect x=\"36\" y=\"-44\" width=\"44\" height=\"36\" rx=\"3\" fill=\"",
            FRAME,
            "\"/><rect x=\"39\" y=\"-41\" width=\"38\" height=\"30\" fill=\"",
            SCREEN,
            "\"/><path d=\"M42-37h20M42-32h28M42-27h14M42-22h24\" stroke=\"",
            VISOR,
            "\" stroke-width=\"2\"/><rect x=\"42\" y=\"-19\" width=\"4\" height=\"2\" fill=\"",
            SHELL,
            "\"><animate attributeName=\"opacity\" values=\"1;0;1\" dur=\"1s\" repeatCount=\"indefinite\"/></rect>"
        );
    }

    function _deskItems() private pure returns (string memory) {
        return string.concat(
            "<g fill=\"",
            CHAIR,
            "\"><rect x=\"4\" y=\"-4\" width=\"26\" height=\"4\" rx=\"1\"/>",
            "<rect x=\"56\" y=\"-9\" width=\"4\" height=\"9\"/>",
            "<rect x=\"48\" y=\"-3\" width=\"20\" height=\"3\" rx=\"1\"/></g>",
            "<rect x=\"82\" y=\"-9\" width=\"7\" height=\"9\" rx=\"1\" fill=\"",
            ACCENT,
            "\"/>"
        );
    }
}
