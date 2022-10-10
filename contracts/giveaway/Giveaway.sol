// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../interfaces/UsePointCallee.sol";

/// @notice Giveaway
contract Giveaway is OwnableUpgradeable, UsePointCallee {
    using SafeERC20 for IERC20;

    address public contributionPoint;
    address public token;
    uint256 internal multiplier;

    function initialize(
        address _contributionPoint,
        address _token,
        uint256 _multiplier
    ) external initializer {
        contributionPoint = _contributionPoint;
        token = _token;
        multiplier = _multiplier;

        __Ownable_init();
    }

    function usePointCallback(uint256 amount, bytes calldata data) external {
        require(msg.sender == contributionPoint, "NOT ALLOWED");
        (address to) = abi.decode(data, (address));
        IERC20(token).safeTransfer(to, amount * multiplier);
    }

    function sweep(uint256 amount, address to) external onlyOwner {
        IERC20(token).safeTransfer(to, amount);
    }
}
