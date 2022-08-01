// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "./SVGGenerator.sol";
import "./interfaces/IContributionPoint.sol";

library TokenURIGenerator {

    function tokenURI(uint256 tokenId) internal view returns (string memory) {
        address contributor = IERC721(address(this)).ownerOf(tokenId);
        string memory svg = SVGGenerator.image(tokenId, contributor, IContributionPoint(address(this)).contributionPointOf(contributor));
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{',
                        '"name": "CONTRIBUTOR #', Strings.toString(tokenId), '", ',
                        '"image": "data:image/svg+xml;base64,', Base64.encode(bytes(svg)), '", ',
                        '"description": "PANGEA Contribution Point, this NFT represents contribution point for PANGEA contributors",',
                        '"attributes": [',
                        contributorNumText(contributor),
                        contributionsText(contributor),
                        ']}'
                    )
                )
            )
        );
        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    function contributorNumText(address contributor) private view returns (string memory) {
        int256 point = IContributionPoint(address(this)).contributionPointOf(contributor);
        uint256 numContributions = IContributionPoint(address(this)).contributionRecordCounts(contributor);
        string memory pointMessage = point > 0
            ? Strings.toString(uint256(point))
        : string(abi.encodePacked("-", Strings.toString(uint256(-point))));

        return string(abi.encodePacked(
                '{"display_type": "number", "trait_type":"numOfContributions","value":', Strings.toString(numContributions),"}",
                ',{"display_type": "number", "trait_type":"totalPoints","value":',pointMessage,"}"
            ));
    }

    function contributionsText(address contributor) private view returns (string memory text) {
        uint256 length = IContributionPoint(address(this)).contributionRecordCounts(contributor);
        if (length > 0) {
            text = '';
            {
                uint256 firstContributedTime = IContributionPoint(address(this)).contributionRecordByIndex(contributor,0).time;
                text = string(abi.encodePacked(
                        text, ',{"display_type": "date", "trait_type":"joinDate","value":', Strings.toString(firstContributedTime), "}"
                    ));
            }
            {
                for (uint256 i = 0;i < length; i++) {
                    IContributionPoint.ContributionRecord memory record = IContributionPoint(address(this)).contributionRecordByIndex(contributor, i);

                    string memory desc = IContributionPoint(address(this)).tagDescription(record.tagId);

                    text = string(abi.encodePacked(
                            text, ',{"trait_type":"', desc,',","value": "',Strings.toString(uint256(record.point)),'"}'
                        ));
                }
            }
        } else {
            text = '';
        }
    }
}
