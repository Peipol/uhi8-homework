// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseHook} from "v4-periphery/src/base/hooks/BaseHook.sol";
import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";
import {Hooks} from "v4-core/libraries/Hooks.sol";
import {PoolKey} from "v4-core/types/PoolKey.sol";
import {BalanceDelta} from "v4-core/types/BalanceDelta.sol";
import {BeforeSwapDelta, BeforeSwapDeltaLibrary} from "v4-core/types/BeforeSwapDelta.sol";

/// @title TemplateHook
/// @notice Template for creating new Uniswap v4 hooks
/// @dev Copy this file and customize it for your use case
contract TemplateHook is BaseHook {
    // State variables
    // Add your state variables here

    // Events
    // Add your custom events here

    // Errors
    // Add your custom errors here

    constructor(IPoolManager _poolManager) BaseHook(_poolManager) {
        // Initialize your hook here
    }

    /// @notice Returns the hook's permissions
    /// @dev Customize this to specify which callbacks your hook implements
    function getHookPermissions() public pure override returns (Hooks.Permissions memory) {
        return Hooks.Permissions({
            beforeInitialize: false,    // Set to true if you want to implement this
            afterInitialize: false,     // Set to true if you want to implement this
            beforeAddLiquidity: false,  // Set to true if you want to implement this
            afterAddLiquidity: false,   // Set to true if you want to implement this
            beforeRemoveLiquidity: false, // Set to true if you want to implement this
            afterRemoveLiquidity: false,  // Set to true if you want to implement this
            beforeSwap: false,          // Set to true if you want to implement this
            afterSwap: false,           // Set to true if you want to implement this
            beforeDonate: false,        // Set to true if you want to implement this
            afterDonate: false,         // Set to true if you want to implement this
            beforeSwapReturnDelta: false,
            afterSwapReturnDelta: false,
            afterAddLiquidityReturnDelta: false,
            afterRemoveLiquidityReturnDelta: false
        });
    }

    // Implement only the callbacks you need below
    // Remove or comment out the ones you don't use

    /*
    function beforeInitialize(
        address sender,
        PoolKey calldata key,
        uint160 sqrtPriceX96,
        bytes calldata hookData
    ) external override onlyPoolManager returns (bytes4) {
        // Your logic here
        return this.beforeInitialize.selector;
    }

    function afterInitialize(
        address sender,
        PoolKey calldata key,
        uint160 sqrtPriceX96,
        int24 tick,
        bytes calldata hookData
    ) external override onlyPoolManager returns (bytes4) {
        // Your logic here
        return this.afterInitialize.selector;
    }

    function beforeSwap(
        address sender,
        PoolKey calldata key,
        IPoolManager.SwapParams calldata params,
        bytes calldata hookData
    ) external override onlyPoolManager returns (bytes4, BeforeSwapDelta, uint24) {
        // Your logic here
        return (this.beforeSwap.selector, BeforeSwapDeltaLibrary.ZERO_DELTA, 0);
    }

    function afterSwap(
        address sender,
        PoolKey calldata key,
        IPoolManager.SwapParams calldata params,
        BalanceDelta delta,
        bytes calldata hookData
    ) external override onlyPoolManager returns (bytes4, int128) {
        // Your logic here
        return (this.afterSwap.selector, 0);
    }

    function beforeAddLiquidity(
        address sender,
        PoolKey calldata key,
        IPoolManager.ModifyLiquidityParams calldata params,
        bytes calldata hookData
    ) external override onlyPoolManager returns (bytes4) {
        // Your logic here
        return this.beforeAddLiquidity.selector;
    }

    function afterAddLiquidity(
        address sender,
        PoolKey calldata key,
        IPoolManager.ModifyLiquidityParams calldata params,
        BalanceDelta delta,
        bytes calldata hookData
    ) external override onlyPoolManager returns (bytes4, BalanceDelta) {
        // Your logic here
        return (this.afterAddLiquidity.selector, delta);
    }

    function beforeRemoveLiquidity(
        address sender,
        PoolKey calldata key,
        IPoolManager.ModifyLiquidityParams calldata params,
        bytes calldata hookData
    ) external override onlyPoolManager returns (bytes4) {
        // Your logic here
        return this.beforeRemoveLiquidity.selector;
    }

    function afterRemoveLiquidity(
        address sender,
        PoolKey calldata key,
        IPoolManager.ModifyLiquidityParams calldata params,
        BalanceDelta delta,
        bytes calldata hookData
    ) external override onlyPoolManager returns (bytes4, BalanceDelta) {
        // Your logic here
        return (this.afterRemoveLiquidity.selector, delta);
    }

    function beforeDonate(
        address sender,
        PoolKey calldata key,
        uint256 amount0,
        uint256 amount1,
        bytes calldata hookData
    ) external override onlyPoolManager returns (bytes4) {
        // Your logic here
        return this.beforeDonate.selector;
    }

    function afterDonate(
        address sender,
        PoolKey calldata key,
        uint256 amount0,
        uint256 amount1,
        bytes calldata hookData
    ) external override onlyPoolManager returns (bytes4) {
        // Your logic here
        return this.afterDonate.selector;
    }
    */

    // Add your custom helper functions below
}
