// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/// @title Agent2
/// @notice A round, rose-colored botanist examining a seedling through a hand lens.
///         Desk-local coordinates, shared chair and palette; see STYLE.md.
library Agent2 {
    /// @notice Complete drawing including the single desk object, before placement.
    function draw() internal pure returns (string memory) {
        return string.concat(character(), deskObject());
    }

    /// @notice Chair, round robot and its handheld magnifying glass.
    function character() internal pure returns (string memory) {
        return string.concat(
            '<g fill="#3d4460"><rect x="-34" y="-34" width="6" height="50" rx="2"/>',
            '<rect x="-32" y="12" width="30" height="5" rx="1"/>',
            '<rect x="-19" y="17" width="4" height="24"/>',
            '<rect x="-30" y="40" width="26" height="3" rx="1"/></g>',
            '<rect x="-24" y="4" width="24" height="8" rx="3" fill="#5b6f99"/>',
            '<ellipse cx="-19" cy="-12" rx="11" ry="20" fill="#e07a8a"/>',
            '<circle cx="-18" cy="-43" r="11" fill="#e6e9f0"/>',
            '<circle cx="-11" cy="-43" r="4" fill="#35d0b5"/>',
            '<circle cx="-9" cy="-43" r="1.5" fill="#101522"/>',
            '<path d="M-14-18L0-10 7-17" fill="none" stroke="#e07a8a" stroke-width="5" stroke-linecap="round"/>',
            '<g fill="none" stroke="#e6e9f0" stroke-width="2"><path d="M3-10L10-18"/><circle cx="14" cy="-23" r="6"/></g>'
        );
    }

    /// @notice One small potted seedling. A leaf gently changes opacity over two seconds.
    function deskObject() internal pure returns (string memory) {
        return string.concat(
            '<path d="M29-11h16L42 0H32Z" fill="#f5a860"/>',
            '<path d="M37-11v-20" stroke="#9bd36a" stroke-width="2"/>',
            '<path d="M37-19Q25-19 27-28Q37-28 37-19" fill="#9bd36a"/>',
            '<path d="M37-25Q37-34 46-33Q46-25 37-25" fill="#9bd36a">',
            '<animate attributeName="opacity" values="0.65;1;0.65" dur="2s" repeatCount="indefinite"/></path>'
        );
    }
}
