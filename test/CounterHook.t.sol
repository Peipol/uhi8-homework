// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {Deployers} from "v4-core/test/utils/Deployers.sol";
import {PoolManager} from "v4-core/PoolManager.sol";
import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";
import {Currency, CurrencyLibrary} from "v4-core/types/Currency.sol";
import {PoolId, PoolIdLibrary} from "v4-core/types/PoolId.sol";
import {PoolKey} from "v4-core/types/PoolKey.sol";
import {Hooks} from "v4-core/libraries/Hooks.sol";
import {TickMath} from "v4-core/libraries/TickMath.sol";
import {CounterHook} from "../src/CounterHook.sol";
import {PoolSwapTest} from "v4-core/test/PoolSwapTest.sol";
import {LiquidityAmounts} from "v4-core/test/utils/LiquidityAmounts.sol";

contract CounterHookTest is Test, Deployers {
    using PoolIdLibrary for PoolKey;
    using CurrencyLibrary for Currency;

    CounterHook hook;
    PoolKey poolKey;
    PoolId poolId;

    function setUp() public {
        // Deploy the pool manager
        deployFreshManagerAndRouters();

        // Deploy the hook
        address hookAddress = address(
            uint160(Hooks.BEFORE_SWAP_FLAG | Hooks.AFTER_SWAP_FLAG)
        );
        
        deployCodeTo("CounterHook.sol", abi.encode(manager), hookAddress);
        hook = CounterHook(hookAddress);

        // Initialize a pool with the hook
        (poolKey, poolId) = initPool(
            currency0,
            currency1,
            hook,
            3000, // 0.3% fee
            SQRT_PRICE_1_1,
            ZERO_BYTES
        );

        // Add initial liquidity
        modifyLiquidityRouter.modifyLiquidity(
            poolKey,
            IPoolManager.ModifyLiquidityParams({
                tickLower: -60,
                tickUpper: 60,
                liquidityDelta: 10 ether,
                salt: bytes32(0)
            }),
            ZERO_BYTES
        );
    }

    function test_swapIncrementsCounter() public {
        // Get initial count
        uint256 initialCount = hook.getSwapCount(poolKey);
        assertEq(initialCount, 0, "Initial count should be 0");

        // Perform a swap
        swap(poolKey, true, 1e18, ZERO_BYTES);

        // Check that count increased
        uint256 newCount = hook.getSwapCount(poolKey);
        assertEq(newCount, 1, "Count should be 1 after swap");
    }

    function test_multipleSwapsIncrementCounter() public {
        // Perform multiple swaps
        swap(poolKey, true, 1e18, ZERO_BYTES);
        swap(poolKey, false, 1e18, ZERO_BYTES);
        swap(poolKey, true, 5e17, ZERO_BYTES);

        // Check final count
        uint256 finalCount = hook.getSwapCount(poolKey);
        assertEq(finalCount, 3, "Count should be 3 after three swaps");
    }

    function test_hookPermissions() public view {
        Hooks.Permissions memory permissions = hook.getHookPermissions();
        
        assertTrue(permissions.beforeSwap, "beforeSwap should be enabled");
        assertTrue(permissions.afterSwap, "afterSwap should be enabled");
        assertFalse(permissions.beforeInitialize, "beforeInitialize should be disabled");
        assertFalse(permissions.afterInitialize, "afterInitialize should be disabled");
        assertFalse(permissions.beforeAddLiquidity, "beforeAddLiquidity should be disabled");
    }
}
