.PHONY: install build test clean deploy

# Install dependencies
install:
	forge install foundry-rs/forge-std --no-commit
	forge install Uniswap/v4-core --no-commit
	forge install Uniswap/v4-periphery --no-commit

# Build the project
build:
	forge build

# Run tests
test:
	forge test

# Run tests with verbosity
test-v:
	forge test -vvv

# Run a specific test
test-match:
	forge test --match-test $(TEST)

# Clean build artifacts
clean:
	forge clean
	rm -rf cache out

# Deploy CounterHook
deploy:
	forge script script/DeployCounterHook.s.sol --rpc-url $(RPC_URL) --broadcast

# Format code
format:
	forge fmt

# Check formatting
format-check:
	forge fmt --check

# Generate gas report
gas-report:
	forge test --gas-report

# Run coverage
coverage:
	forge coverage

# Update dependencies
update:
	forge update
