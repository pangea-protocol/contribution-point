// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0;

import "./resources/Logo.sol";
import "./resources/Font.sol";
import "./resources/Background.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

library SVGGenerator {
    string internal constant CANVAS =
    '<svg xmlns="http://www.w3.org/2000/svg" width="264" height="244" version="1.1" font-family="volcano" fill="#ffffff">';
    string internal constant TITLE = '<text x="16" y="31" font-size="18px">Contribution Points</text>';
    string internal constant FOOTER = '<rect x="0" y="212" width="264" height="32"  fill="#000000"/>';
    string internal constant POINT = '<text x="248" y="135" text-anchor="end" font-size="12px">points</text>';
    string internal constant END = "</svg>";


    function image(uint256 tokenId, address owner, int256 point) internal pure returns (string memory) {
        return string(
            abi.encodePacked(SVGImage(), tokenIdMessage(tokenId), pointMessage(point), addressMessage(owner))
        );
    }

    function tokenIdMessage(uint256 tokenId) internal pure returns (string memory) {
        string memory text = '';
        for (uint256 i = 5; i > 0; i--) {
            text = string(abi.encodePacked(text, Strings.toString((tokenId / 10 ** i) % 10)));
        }

        return string(abi.encodePacked(
        '<text x="248" y="31" text-anchor="end" font-size="15px"># ',
        text,
        '</text>'
        ));
    }

    function pointMessage(int256 point) internal pure returns (string memory) {
        string memory text = point > 0
        ? Strings.toString(uint256(point))
        : string(abi.encodePacked("-", Strings.toString(uint256(-point))));
        return string(abi.encodePacked(
                '<text x="248" y="120" text-anchor="end" font-size="20px">',
                    text,
                    '</text>'
            ));
    }

    function addressMessage(address owner) internal pure returns (string memory) {
        return string(abi.encodePacked(
            '<text x="80" y="230" text-anchor="right" font-size="8px">',
            Strings.toHexString(uint160(owner),20),
            '</text>'
        ));
    }

    function SVGImage() internal pure returns (string memory) {
        return string(abi.encodePacked(CANVAS, Background.IMAGE(), TITLE, POINT, Font.RESOURCE(), Logo.RESOURCE(), FOOTER));
    }
}
