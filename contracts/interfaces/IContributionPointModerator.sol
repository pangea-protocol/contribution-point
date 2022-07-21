// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0;

import "./IContributionStruct.sol";

interface IContributionPointModerator is IContributionStruct {
    function createTag(string memory desc) external returns (uint32 tagId);

    function updateTagDescription(uint32 tagId, string memory desc) external;

    function createRecord(address contributor, uint32 tagId, uint32 point) external;

    function updateRecord(address contributor, uint256 orderId, uint32 point) external;

    function deleteRecord(address contributor, uint256 orderId) external returns (ContributionRecord memory record);
}
