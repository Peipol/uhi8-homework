# Uniswap Hook Incubator - Homework Repository

This repository is for practicing hook development using Foundry and Uniswap v4.

## Overview

This project provides a foundation for learning and experimenting with Uniswap v4 hooks. It includes:
- A sample `CounterHook` that demonstrates basic hook functionality
- Test infrastructure using Foundry
- Deployment scripts for deploying hooks

## Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) - Smart contract development framework
- Git for version control

## Installation

1. Clone the repository:
```bash
git clone https://github.com/Peipol/uhi8-homework.git
cd uhi8-homework
```

2. Install dependencies:
```bash
make install
```

Or manually:
```bash
forge install foundry-rs/forge-std --no-commit
forge install Uniswap/v4-core --no-commit
forge install Uniswap/v4-periphery --no-commit
```

3. Build the project:
```bash
make build
```

## Quick Start

```bash
# Install dependencies
make install

# Build contracts
make build

# Run all tests
make test

# Run tests with verbose output
make test-v

# Run a specific test
make test-match TEST=test_swapIncrementsCounter

# Clean build artifacts
make clean
```

## Project Structure

```
.
├── src/                      # Smart contracts
│   ├── CounterHook.sol      # Example hook that counts swaps
│   └── WhitelistHook.sol    # Example hook with access control
├── test/                     # Test files
│   ├── CounterHook.t.sol    # Tests for CounterHook
│   └── WhitelistHook.t.sol  # Tests for WhitelistHook
├── script/                   # Deployment scripts
│   └── DeployCounterHook.s.sol
├── foundry.toml             # Foundry configuration
├── remappings.txt           # Import remappings
├── Makefile                 # Common development tasks
└── CONTRIBUTING.md          # Guide for hook development
```

## Usage

### Running Tests

Run all tests:
```bash
forge test
```

Run tests with verbosity:
```bash
forge test -vvv
```

Run a specific test:
```bash
forge test --match-test test_swapIncrementsCounter
```

### Building

Compile the contracts:
```bash
forge build
```

### Deploying

To deploy the CounterHook:

1. Set up your environment variables in `.env`:
```bash
PRIVATE_KEY=your_private_key
POOL_MANAGER_ADDRESS=uniswap_v4_pool_manager_address
```

2. Run the deployment script:
```bash
forge script script/DeployCounterHook.s.sol --rpc-url <your_rpc_url> --broadcast
```

## Example Hooks

### 1. CounterHook

The `CounterHook` is a simple educational example that:
- Implements `beforeSwap` and `afterSwap` hooks
- Counts the number of swaps per pool
- Emits events when swaps are counted
- Demonstrates basic hook callback implementation

### 2. WhitelistHook

The `WhitelistHook` demonstrates access control patterns:
- Implements `beforeSwap` hook
- Restricts swaps to whitelisted addresses only
- Shows owner-based access control
- Demonstrates how to enforce permissions in hooks

Both examples serve as starting points for understanding how hooks work in Uniswap v4.

## Learning Resources

- [Uniswap v4 Core](https://github.com/Uniswap/v4-core)
- [Uniswap v4 Periphery](https://github.com/Uniswap/v4-periphery)
- [Foundry Book](https://book.getfoundry.sh/)
- [Uniswap Hook Incubator](https://uniswaphooks.com/)

## Development Tips

1. **Hook Permissions**: Define which callbacks your hook implements in `getHookPermissions()`
2. **Hook Address**: Hook addresses must have specific prefixes based on which callbacks they implement
3. **Testing**: Use the test utilities from v4-core for pool initialization and liquidity management
4. **Gas Optimization**: Hooks are called frequently, so optimize for gas efficiency

## License

MIT
