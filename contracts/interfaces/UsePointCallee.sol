// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0;

interface UsePointCallee {
    function usePointCallback(uint256 amount, bytes calldata data) external;
}
