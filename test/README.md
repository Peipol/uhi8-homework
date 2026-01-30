# Tests

This directory contains test files for the Uniswap v4 hooks.

## Test Files

### CounterHook.t.sol
Tests for the CounterHook contract:
- ✓ Swap counting functionality
- ✓ Counter increments correctly
- ✓ Multiple swaps tracking
- ✓ Hook permissions validation

### WhitelistHook.t.sol
Tests for the WhitelistHook contract:
- ✓ Whitelist management (add/remove)
- ✓ Access control (owner-only functions)
- ✓ Swap restrictions for non-whitelisted addresses
- ✓ Successful swaps for whitelisted addresses
- ✓ Hook permissions validation

## Running Tests

### Run All Tests
```bash
forge test
```

### Run with Verbosity
```bash
forge test -vvv
```

### Run Specific Test File
```bash
forge test --match-path test/CounterHook.t.sol
```

### Run Specific Test Function
```bash
forge test --match-test test_swapIncrementsCounter
```

### Run with Gas Report
```bash
forge test --gas-report
```

### Run with Coverage
```bash
forge coverage
```

## Writing Tests

When creating tests for your hooks, inherit from:
- `Test`: Foundry's test utilities
- `Deployers`: Uniswap v4 deployment helpers

### Basic Test Structure

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {Deployers} from "v4-core/test/utils/Deployers.sol";

contract YourHookTest is Test, Deployers {
    YourHook hook;
    PoolKey poolKey;
    
    function setUp() public {
        // 1. Deploy pool manager and routers
        deployFreshManagerAndRouters();
        
        // 2. Deploy your hook
        address hookAddress = address(uint160(YOUR_FLAGS));
        deployCodeTo("YourHook.sol", abi.encode(manager), hookAddress);
        hook = YourHook(hookAddress);
        
        // 3. Initialize pool
        (poolKey,) = initPool(
            currency0,
            currency1,
            hook,
            3000,
            SQRT_PRICE_1_1,
            ZERO_BYTES
        );
        
        // 4. Add initial liquidity
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
    
    function test_yourFeature() public {
        // Your test logic
    }
}
```

## Test Utilities

### Deployers Helpers
- `deployFreshManagerAndRouters()`: Sets up pool manager
- `initPool()`: Initializes a new pool with hook
- `swap()`: Executes a swap
- `modifyLiquidityRouter`: Adds/removes liquidity

### Common Assertions
- `assertEq()`: Check equality
- `assertTrue()`: Check boolean
- `assertFalse()`: Check boolean negation
- `vm.expectRevert()`: Expect a revert
- `vm.prank()`: Set msg.sender for next call

## Best Practices

1. **Test Each Callback**: Write tests for each hook callback
2. **Edge Cases**: Test boundary conditions
3. **Reverts**: Test that invalid inputs revert correctly
4. **Events**: Check that events are emitted correctly
5. **State Changes**: Verify state changes after operations
6. **Gas**: Monitor gas usage with `--gas-report`
7. **Permissions**: Test hook permissions are correct

## Debugging

### Increase Verbosity
Add more `v`s for detailed traces:
```bash
forge test -vvvv
```

### Trace Specific Test
```bash
forge test --match-test yourTest -vvvv
```

### Use Console Logs
```solidity
import {console} from "forge-std/console.sol";

console.log("Value:", someValue);
```

## Resources

- [Foundry Testing Guide](https://book.getfoundry.sh/forge/tests)
- [Uniswap v4 Test Utils](https://github.com/Uniswap/v4-core/tree/main/test)
- See `CONTRIBUTING.md` for more hook development guidance
