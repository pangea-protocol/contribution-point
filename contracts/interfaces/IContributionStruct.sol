// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0;

interface IContributionStruct {
    struct ContributionRecord {
        uint32 tagId;
        uint32 time;
        uint32 point;
    }
}
