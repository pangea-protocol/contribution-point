// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/MulticallUpgradeable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./interfaces/UsePointCallee.sol";
import "./interfaces/IContributionPoint.sol";
import "./interfaces/IContributionPointModerator.sol";

/// @notice Contribution Point membership NFT
contract ContributionPoint is
    IContributionPoint,
    IContributionPointModerator,
    ERC721Upgradeable,
    AccessControlUpgradeable,
    MulticallUpgradeable {
    using Strings for uint256;
    bytes32 public constant MANAGER_ROLE = keccak256("MANAGER");
    mapping(address => ContributionRecord[]) private _contributionRecords;
    mapping(address => int256) private _pointOf;

    string[] private _tagDescriptions;

    mapping(address => uint256) private _contributorIdOf;
    uint256 private _contributorCounter;

    //////////////////////////////////////////////
    // functions Related to Initialization
    //////////////////////////////////////////////
    function initialize(string memory name_, string memory symbol_) external initializer {
            __ERC721_init(name_, symbol_);
            __AccessControl_init();
            __Multicall_init();

            _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
            registerContributor(_msgSender());
    }

    modifier managerOnly() {
        require(hasRole(MANAGER_ROLE, _msgSender()), "ONLY MANAGER");
        _;
    }

    function supportsInterface(bytes4 interfaceId) public view
    override(ERC721Upgradeable, AccessControlUpgradeable) returns (bool) {
        return (
            ERC721Upgradeable.supportsInterface(interfaceId) ||
            AccessControlUpgradeable.supportsInterface(interfaceId)
        );
    }

    //////////////////////////////////////////////
    // View Functions
    /////////////////////////////////////////////
    function tokenURI(uint256 contributorId) public view override returns (string memory) {
        address contributor = ownerOf(contributorId);
        int256 point = _pointOf[contributor];
        string memory pointMessage = point > 0 ? uint256(point).toString() : string(abi.encodePacked("-", uint256(-point).toString()));
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{',
                        '"name": "CONTRIBUTOR #', contributorId.toString(), '", ',
                        '"description": "PANGEA Contribution Point, this NFT represents contribution point for PANGEA contributors",',
                        '"attributes": [',
                            '{"trait_type":"numOfContributions","value":',uint256(_contributionRecords[contributor].length).toString(),"},",
                            '{"trait_type":"totalPoints","value":',pointMessage,"}]",
                        '}'
                    )
                )
            )
        );
        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    function totalSupply() external view returns (uint256) {
        return _contributorCounter;
    }

    function contributorIdOf(address contributor) external view returns (uint256) {
        require(balanceOf(contributor) > 0, "NO MEMBERSHIP");
        return _contributorIdOf[contributor];
    }

    function totalTags() external view returns (uint256) {
        return _tagDescriptions.length;
    }

    /// @notice return contribution tag description
    function tagDescription(uint32 tagId) external view returns (string memory) {
        return _tagDescriptions[tagId];
    }

    // @notice returns the length of contribution record
    function contributionRecordCounts(address contributor) external view returns (uint256) {
        return _contributionRecords[contributor].length;
    }

    // @notice read record by index
    function contributionRecordByIndex(address contributor, uint256 orderId) external view returns (ContributionRecord memory) {
        return _contributionRecords[contributor][orderId];
    }

    // @notice read records by range
    function contributionRecords(address contributor, uint256 start, uint256 nums) external view returns (ContributionRecord[] memory records) {
        ContributionRecord[] memory _contributorRecords = _contributionRecords[contributor];
        uint256 end = Math.min(start + nums - 1, _contributorRecords.length - 1);
        require(start <= end, "NO RECORDS");

        records = new ContributionRecord[](end - start + 1);
        for (uint256 i = start; i <= end; i++) {
            records[i - start] = _contributorRecords[i];
        }
    }

    // @notice read total contribution point which contributor take
    function contributionPointOf(address contributor) external view returns (int256) {
        return _pointOf[contributor];
    }

    //////////////////////////////////////////////
    // contributor's function
    //////////////////////////////////////////////
    function usePoint(uint32 amount, address to, bytes calldata data) external {
        int256 balance = _pointOf[_msgSender()];
        require(balance > 0 && uint256(amount) <= uint256(balance), "INSUFFICIENT");
        _pointOf[_msgSender()] -= castToInt256(amount);

        UsePointCallee(to).usePointCallback(amount, data);
    }

    //////////////////////////////////////////////
    // manipulation functions
    //
    // only manager can call
    /////////////////////////////////////////////
    function createTag(string memory desc) external managerOnly returns (uint32 tagId) {
        require(_tagDescriptions.length < type(uint32).max);

        _tagDescriptions.push(desc);
        return uint32(_tagDescriptions.length - 1);
    }

    function updateTagDescription(uint32 tagId, string memory desc) external managerOnly {
        require(tagId < _tagDescriptions.length, "INVALID TAG ID");
        _tagDescriptions[tagId] = desc;
    }

    //////////////////////////////////////////////
    // manipulation functions Related To Contribution Records
    /////////////////////////////////////////////

    /// @notice create contribution record
    function createRecord(address contributor, uint32 tagId, uint32 point) external managerOnly {
        require(tagId < _tagDescriptions.length, "INVALID TAG ID");
        require(point > 0, "NOT ZERO");

        if (balanceOf(contributor) == 0) {
            // first, register
            registerContributor(contributor);
        }

        _contributionRecords[contributor].push(ContributionRecord(tagId, uint32(block.timestamp), point));
        _pointOf[contributor] += castToInt256(point);
    }

    /// @notice modify contribution record
    function updateRecord(address contributor, uint256 orderId, uint32 point) external managerOnly {
        require(point > 0, "NOT ZERO");
        require(orderId < _contributionRecords[contributor].length, "INVALID ORDER ID");

        uint32 prevPoint = _contributionRecords[contributor][orderId].point;
        _contributionRecords[contributor][orderId].point = point;

        if (prevPoint < point) {
            _pointOf[contributor] += castToInt256(point - prevPoint);
        } else {
            _pointOf[contributor] -= castToInt256(prevPoint - point);
        }
    }

    /// @notice delete contribution record
    function deleteRecord(address contributor, uint256 orderId) external managerOnly returns (ContributionRecord memory record) {
        ContributionRecord[] storage records = _contributionRecords[contributor];
        record = records[orderId];
        for (uint i = orderId; i < records.length -1; i++) {
            records[i] = records[i+1];
        }
        records.pop();

        _pointOf[contributor] -= castToInt256(record.point);
    }

    function registerContributor(
        address contributor
    ) private {
        _mint(contributor, _contributorCounter);
        _contributorIdOf[contributor] = _contributorCounter;
        _contributorCounter++;
    }

    /// @dev block to transfer or multiple mint
    function _beforeTokenTransfer(address from, address, uint256) internal pure override {
        require(from == address(0), "NOT-TRANSFERABLE");
    }

    function castToInt256(uint32 x) private pure returns (int256 y) {
        y = int256(uint256(x));
    }
}
