// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0;

import "./resources/Logo.sol";
import "./resources/Font.sol";
import "./resources/Background.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

library SVGGenerator {
    string internal constant CANVAS =
    '<svg xmlns="http://www.w3.org/2000/svg" width="264" height="244" version="1.1" font-family="volcano" fill="#ffffff">';
    string internal constant TITLE = '<text x="18" y="25" font-size="10.5">Contribution Points</text>';
    string internal constant HEADER = '<rect x="16" y="16" width="232" height="11" fill="#000000"/>';
    string internal constant POINT = '<text x="240" y="136" text-anchor="end" font-size="14" fill="#000000">points</text>';
    string internal constant END = "</svg>";


    function image(uint256 tokenId, address owner, int256 point) external pure returns (string memory) {
        return string(
            abi.encodePacked(SVGImage(), tokenIdMessage(tokenId), pointMessage(point), addressMessage(owner), END)
        );
    }

    function tokenIdMessage(uint256 tokenId) internal pure returns (string memory) {
        string memory text = '';
        for (uint256 i = 5; i > 0; i--) {
            text = string(abi.encodePacked(text, Strings.toString((tokenId % 10 ** i) / (10 ** (i-1)))));
        }

        return string(abi.encodePacked(
        '<text x="245" y="25" text-anchor="end" font-size="10">#',
        text,
        '</text>'
        ));
    }

    function pointMessage(int256 point) internal pure returns (string memory) {
        string memory text = point > 0
        ? Strings.toString(uint256(point))
        : string(abi.encodePacked("-", Strings.toString(uint256(-point))));
        return string(abi.encodePacked(
                '<text x="240" y="122" text-anchor="end" font-size="24" fill="#000000">',
                    text,
                    '</text>'
            ));
    }

    function addressMessage(address owner) internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<text x="132" y="225" text-anchor="middle" font-size="8" font-family="IBMPlexSans" fill="#000000">',
            Strings.toHexString(uint160(owner), 20),
            '</text>'
        ));
    }

    function SVGImage() internal pure returns (string memory) {
        return string(abi.encodePacked(CANVAS, Background.IMAGE(), HEADER, TITLE, POINT, Font.RESOURCE(), Logo.RESOURCE()));
    }
}
