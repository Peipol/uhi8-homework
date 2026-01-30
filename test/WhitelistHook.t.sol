// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {Deployers} from "v4-core/test/utils/Deployers.sol";
import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";
import {Currency} from "v4-core/types/Currency.sol";
import {PoolId, PoolIdLibrary} from "v4-core/types/PoolId.sol";
import {PoolKey} from "v4-core/types/PoolKey.sol";
import {Hooks} from "v4-core/libraries/Hooks.sol";
import {WhitelistHook} from "../src/WhitelistHook.sol";

contract WhitelistHookTest is Test, Deployers {
    using PoolIdLibrary for PoolKey;

    WhitelistHook hook;
    PoolKey poolKey;
    PoolId poolId;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    function setUp() public {
        // Deploy the pool manager
        deployFreshManagerAndRouters();

        // Deploy the hook at a specific address with BEFORE_SWAP_FLAG
        address hookAddress = address(uint160(Hooks.BEFORE_SWAP_FLAG));
        
        deployCodeTo("WhitelistHook.sol", abi.encode(manager), hookAddress);
        hook = WhitelistHook(hookAddress);

        // Initialize a pool with the hook
        (poolKey, poolId) = initPool(
            currency0,
            currency1,
            hook,
            3000,
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

    function test_ownerCanAddToWhitelist() public {
        hook.addToWhitelist(alice);
        assertTrue(hook.whitelist(alice), "Alice should be whitelisted");
    }

    function test_ownerCanRemoveFromWhitelist() public {
        hook.addToWhitelist(alice);
        hook.removeFromWhitelist(alice);
        assertFalse(hook.whitelist(alice), "Alice should not be whitelisted");
    }

    function test_onlyOwnerCanWhitelist() public {
        vm.prank(alice);
        vm.expectRevert(WhitelistHook.OnlyOwner.selector);
        hook.addToWhitelist(bob);
    }

    function test_whitelistedAddressCanSwap() public {
        // Whitelist the swap router
        hook.addToWhitelist(address(swapRouter));
        
        // This should succeed
        swap(poolKey, true, 1e18, ZERO_BYTES);
    }

    function test_nonWhitelistedAddressCannotSwap() public {
        // Don't whitelist the swap router
        
        // This should revert
        vm.expectRevert(WhitelistHook.NotWhitelisted.selector);
        swap(poolKey, true, 1e18, ZERO_BYTES);
    }

    function test_hookPermissions() public view {
        Hooks.Permissions memory permissions = hook.getHookPermissions();
        
        assertTrue(permissions.beforeSwap, "beforeSwap should be enabled");
        assertFalse(permissions.afterSwap, "afterSwap should be disabled");
        assertFalse(permissions.beforeInitialize, "beforeInitialize should be disabled");
    }
}
