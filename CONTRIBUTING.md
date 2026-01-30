# Contributing Guide

This guide will help you understand how to work with this repository and develop Uniswap v4 hooks.

## Getting Started

### 1. Set Up Your Environment

Make sure you have Foundry installed:
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### 2. Install Dependencies

```bash
make install
# or
forge install
```

### 3. Build the Project

```bash
make build
# or
forge build
```

### 4. Run Tests

```bash
make test
# or
forge test -vvv
```

## Understanding Hooks

### What are Uniswap v4 Hooks?

Hooks are contracts that can execute custom logic at various points in a pool's lifecycle:
- Before/after pool initialization
- Before/after liquidity modifications
- Before/after swaps
- Before/after donations

### Hook Permissions

Each hook must declare which callbacks it implements via `getHookPermissions()`. The CounterHook example demonstrates this:

```solidity
function getHookPermissions() public pure override returns (Hooks.Permissions memory) {
    return Hooks.Permissions({
        beforeInitialize: false,
        afterInitialize: false,
        beforeAddLiquidity: false,
        afterAddLiquidity: false,
        beforeRemoveLiquidity: false,
        afterRemoveLiquidity: false,
        beforeSwap: true,      // ✓ We implement this
        afterSwap: true,       // ✓ We implement this
        beforeDonate: false,
        afterDonate: false,
        beforeSwapReturnDelta: false,
        afterSwapReturnDelta: false,
        afterAddLiquidityReturnDelta: false,
        afterRemoveLiquidityReturnDelta: false
    });
}
```

### Hook Addresses

Hook addresses must have specific prefixes based on their permissions. The address is derived from the flags in the permissions. For example:
- `beforeSwap`: bit 7
- `afterSwap`: bit 6

The CounterHook uses: `Hooks.BEFORE_SWAP_FLAG | Hooks.AFTER_SWAP_FLAG`

## Creating Your Own Hook

### Step 1: Create the Contract

Create a new file in `src/YourHook.sol`:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseHook} from "v4-periphery/src/base/hooks/BaseHook.sol";
import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";
import {Hooks} from "v4-core/libraries/Hooks.sol";

contract YourHook is BaseHook {
    constructor(IPoolManager _poolManager) BaseHook(_poolManager) {}
    
    function getHookPermissions() public pure override returns (Hooks.Permissions memory) {
        // Define your permissions here
    }
    
    // Implement your hook callbacks here
}
```

### Step 2: Write Tests

Create `test/YourHook.t.sol`:

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test} from "forge-std/Test.sol";
import {Deployers} from "v4-core/test/utils/Deployers.sol";

contract YourHookTest is Test, Deployers {
    function setUp() public {
        // Set up your test environment
    }
    
    function test_yourFeature() public {
        // Write your tests
    }
}
```

### Step 3: Test Your Hook

```bash
forge test --match-contract YourHookTest -vvv
```

## Common Patterns

### 1. Counting or Tracking

Track pool activity (like CounterHook):
- Use mappings with pool IDs as keys
- Emit events for off-chain tracking

### 2. Fee Modifications

Dynamically adjust fees based on conditions:
- Implement `beforeSwap` with dynamic fee tier
- Return custom fee in the third return value

### 3. Access Control

Restrict who can interact with pools:
- Check `msg.sender` or other conditions
- Revert if conditions aren't met

### 4. Oracle Integration

Update or use price oracles:
- Store TWAP data in `afterSwap`
- Use stored data in other callbacks

## Testing Tips

1. **Use Deployers**: Inherit from `Deployers` for test utilities
2. **Test Each Callback**: Ensure each hook callback works correctly
3. **Test Edge Cases**: Check boundary conditions and reverts
4. **Gas Optimization**: Run `forge test --gas-report` to check gas usage

## Resources

- [v4-core Documentation](https://github.com/Uniswap/v4-core)
- [v4-periphery Examples](https://github.com/Uniswap/v4-periphery)
- [Foundry Book](https://book.getfoundry.sh/)
- [Solidity Style Guide](https://docs.soliditylang.org/en/latest/style-guide.html)

## Need Help?

- Check the [Uniswap v4 Docs](https://docs.uniswap.org/)
- Look at existing hook examples
- Ask in the Uniswap Discord

Happy hook building! 🦄
