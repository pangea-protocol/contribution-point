// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/MulticallUpgradeable.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";

/// @notice Contribution Point membership NFT
contract ContributionPoint is
    ERC721Upgradeable,
    AccessControlUpgradeable,
    MulticallUpgradeable {

    bytes32 public constant MODERATOR_ROLE = keccak256("MODERATOR");

    struct ContributionRecord {
        uint32 tagId;
        uint32 time;
        uint32 point;
    }
    mapping(address => ContributionRecord[]) private _contributionRecords;
    mapping(address => uint64) private _pointOf;

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

            _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    modifier moderatorOnly() {
        require(hasRole(MODERATOR_ROLE, msg.sender), "Caller is not a moderator");
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
    function totalSupply() external view returns (uint256) {
        return _contributorCounter;
    }

    function contributorIdOf(address contributor) external view returns (uint256) {
        require(balanceOf(contributor) > 0, "NO MEMBERSHIP");
        return _contributorIdOf[contributor];
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
    function contributionRecordByIndex(
        address contributor,
        uint256 orderId
    ) external view returns (ContributionRecord memory) {
        return _contributionRecords[contributor][orderId];
    }

    // @notice read records by range
    function contributionRecords(
        address contributor,
        uint256 startId,
        uint256 nums
    ) external view returns (ContributionRecord[] memory records) {
        ContributionRecord[] memory _contributorRecords = _contributionRecords[contributor];
        uint256 endId = Math.min(startId + nums - 1, _contributorRecords.length - 1);
        require(startId <= endId, "NO RECORDS");

        records = new ContributionRecord[](endId - startId + 1);
        for (uint256 i = startId; i <= endId; i++) {
            records[i - startId] = _contributorRecords[i];
        }
    }

    // @notice read total contribution point which contributor take
    function contributionPointOf(address contributor) external view returns (uint64) {
        return _pointOf[contributor];
    }

    //////////////////////////////////////////////
    // manipulation functions
    //
    // only moderator can call
    //
    /////////////////////////////////////////////
    function createTag(string memory desc) external moderatorOnly returns (uint32 tagId) {
        require(_tagDescriptions.length < type(uint32).max);

        _tagDescriptions.push(desc);
        return uint32(_tagDescriptions.length - 1);
    }

    function updateDescription(uint32 tagId, string memory desc) external moderatorOnly {
        _tagDescriptions[tagId] = desc;
    }

    //////////////////////////////////////////////
    // manipulation functions Related To Contribution Records
    /////////////////////////////////////////////

    /// @notice create contribution record
    function createRecord(address contributor, uint32 tagId, uint32 point) external moderatorOnly {
        require(tagId < _tagDescriptions.length, "INVALID TAG ID");
        require(point > 0, "NOT ZERO");

        if (balanceOf(contributor) == 0) {
            // first, register
            registerContributor(contributor);
        }

        _contributionRecords[contributor].push(ContributionRecord(tagId, uint32(block.timestamp), point));
        _pointOf[contributor] += point;
    }

    /// @notice update contribution record
    function updateRecord(
        address contributor,
        uint256 orderId,
        uint32 point
    ) external moderatorOnly {
        require(point > 0, "NOT ZERO");

        uint32 prevPoint = _contributionRecords[contributor][orderId].point;
        _contributionRecords[contributor][orderId].point = point;

        if (prevPoint < point) {
            _pointOf[contributor] += point - prevPoint;
        } else {
            _pointOf[contributor] -= prevPoint - point;
        }
    }

    /// @notice delete contribution record
    function deleteRecord(
        address contributor,
        uint256 orderId
    ) external
      moderatorOnly
      returns (
        ContributionRecord memory record
    ) {
        ContributionRecord[] storage records = _contributionRecords[contributor];
        record = records[orderId];
        for (uint i = orderId; i < records.length -1; i++) {
            records[i] = records[i+1];
        }
        records.pop();

        _pointOf[contributor] -= record.point;
    }

    function registerContributor(
        address contributor
    ) internal {
        _mint(contributor, _contributorCounter);
        _contributorIdOf[contributor] = _contributorCounter;
        _contributorCounter++;
    }

    /// @dev block to transfer or multiple mint
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256
    ) internal view override {
        // only mint allow
        require(from == address(0), "NOT-TRANSFERABLE");
        require(balanceOf(to) == 0, "ALREADY MINT");
    }
}
