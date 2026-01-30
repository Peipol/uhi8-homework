// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseHook} from "v4-periphery/src/base/hooks/BaseHook.sol";
import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";
import {Hooks} from "v4-core/libraries/Hooks.sol";
import {PoolKey} from "v4-core/types/PoolKey.sol";
import {BalanceDelta} from "v4-core/types/BalanceDelta.sol";
import {BeforeSwapDelta, BeforeSwapDeltaLibrary} from "v4-core/types/BeforeSwapDelta.sol";

/// @title CounterHook
/// @notice A simple example hook that counts the number of swaps
/// @dev This hook demonstrates basic hook functionality for educational purposes
contract CounterHook is BaseHook {
    /// @notice Emitted when a swap is counted
    event SwapCounted(address indexed sender, uint256 count);

    /// @notice Mapping to track swap counts per pool
    mapping(bytes32 => uint256) public swapCounts;

    constructor(IPoolManager _poolManager) BaseHook(_poolManager) {}

    /// @notice Returns the hook's permissions
    /// @dev Specifies which hook callbacks this contract implements
    function getHookPermissions() public pure override returns (Hooks.Permissions memory) {
        return Hooks.Permissions({
            beforeInitialize: false,
            afterInitialize: false,
            beforeAddLiquidity: false,
            afterAddLiquidity: false,
            beforeRemoveLiquidity: false,
            afterRemoveLiquidity: false,
            beforeSwap: true,
            afterSwap: true,
            beforeDonate: false,
            afterDonate: false,
            beforeSwapReturnDelta: false,
            afterSwapReturnDelta: false,
            afterAddLiquidityReturnDelta: false,
            afterRemoveLiquidityReturnDelta: false
        });
    }

    /// @notice Hook called before a swap is executed
    /// @param sender The address initiating the swap
    /// @param key The pool key
    /// @param params The swap parameters
    /// @param hookData Additional data passed to the hook
    /// @return bytes4 The function selector
    /// @return BeforeSwapDelta The delta to apply before the swap
    /// @return uint24 The LP fee to use
    function beforeSwap(
        address sender,
        PoolKey calldata key,
        IPoolManager.SwapParams calldata params,
        bytes calldata hookData
    ) external override onlyPoolManager returns (bytes4, BeforeSwapDelta, uint24) {
        // Increment the swap count for this pool
        bytes32 poolId = keccak256(abi.encode(key));
        swapCounts[poolId]++;
        
        return (this.beforeSwap.selector, BeforeSwapDeltaLibrary.ZERO_DELTA, 0);
    }

    /// @notice Hook called after a swap is executed
    /// @param sender The address initiating the swap
    /// @param key The pool key
    /// @param params The swap parameters
    /// @param delta The balance delta from the swap
    /// @param hookData Additional data passed to the hook
    /// @return bytes4 The function selector
    /// @return int128 The hook delta
    function afterSwap(
        address sender,
        PoolKey calldata key,
        IPoolManager.SwapParams calldata params,
        BalanceDelta delta,
        bytes calldata hookData
    ) external override onlyPoolManager returns (bytes4, int128) {
        bytes32 poolId = keccak256(abi.encode(key));
        emit SwapCounted(sender, swapCounts[poolId]);
        
        return (this.afterSwap.selector, 0);
    }

    /// @notice Get the swap count for a specific pool
    /// @param key The pool key
    /// @return The number of swaps for this pool
    function getSwapCount(PoolKey calldata key) external view returns (uint256) {
        bytes32 poolId = keccak256(abi.encode(key));
        return swapCounts[poolId];
    }
}
