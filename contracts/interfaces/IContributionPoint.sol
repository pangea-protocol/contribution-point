// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0;

import "./IContributionStruct.sol";


interface IContributionPoint is IContributionStruct {
    function totalSupply() external view returns (uint256);

    function contributorIdOf(address contributor) external view returns (uint256);

    function tagDescription(uint32 tagId) external view returns (string memory);

    function contributionRecordCounts(address contributor) external view returns (uint256);

    function contributionRecordByIndex(address contributor, uint256 orderId) external view returns (ContributionRecord memory);

    function contributionRecords(address contributor, uint256 start, uint256 nums) external view returns (ContributionRecord[] memory records);

    function contributionPointOf(address contributor) external view returns (int256);

    function usePoint(uint32 amount, address to, bytes calldata data) external;
}
