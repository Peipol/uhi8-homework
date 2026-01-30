# Smart Contracts

This directory contains Uniswap v4 hook implementations.

## Available Hooks

### CounterHook.sol
A simple hook that counts swaps per pool. Demonstrates:
- Basic hook structure
- `beforeSwap` and `afterSwap` callbacks
- Event emission
- State management with mappings

**Use case**: Learning basic hook mechanics

### WhitelistHook.sol
A hook that restricts swaps to whitelisted addresses. Demonstrates:
- Access control patterns
- Owner-based permissions
- Before-swap validation
- Custom errors

**Use case**: Understanding access control in hooks

### TemplateHook.sol
A blank template for creating new hooks. Features:
- All possible callback signatures (commented out)
- Customizable permissions
- Structured layout for easy customization

**Use case**: Starting point for your own hook implementations

## Creating a New Hook

1. Copy `TemplateHook.sol` and rename it
2. Update the contract name and comments
3. Enable needed permissions in `getHookPermissions()`
4. Uncomment and implement the callbacks you need
5. Add your custom logic and state variables
6. Create corresponding tests in `test/`

## Hook Callback Reference

### Initialization Hooks
- `beforeInitialize`: Called before a pool is initialized
- `afterInitialize`: Called after a pool is initialized

### Liquidity Hooks
- `beforeAddLiquidity`: Called before liquidity is added
- `afterAddLiquidity`: Called after liquidity is added
- `beforeRemoveLiquidity`: Called before liquidity is removed
- `afterRemoveLiquidity`: Called after liquidity is removed

### Swap Hooks
- `beforeSwap`: Called before a swap is executed
- `afterSwap`: Called after a swap is executed

### Donation Hooks
- `beforeDonate`: Called before a donation
- `afterDonate`: Called after a donation

## Best Practices

1. **Minimal Logic**: Keep hook logic simple and gas-efficient
2. **Reentrancy**: Be aware of reentrancy risks
3. **Permissions**: Only enable callbacks you actually use
4. **Testing**: Thoroughly test all edge cases
5. **Events**: Emit events for important state changes
6. **Errors**: Use custom errors for better gas efficiency

## Resources

- [BaseHook Documentation](https://github.com/Uniswap/v4-periphery)
- [Hook Examples](https://github.com/Uniswap/v4-periphery/tree/main/contracts/hooks)
- See `CONTRIBUTING.md` in the root directory for more details
