// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {BaseHook} from "v4-periphery/src/base/hooks/BaseHook.sol";
import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";
import {Hooks} from "v4-core/libraries/Hooks.sol";
import {PoolKey} from "v4-core/types/PoolKey.sol";
import {BeforeSwapDelta, BeforeSwapDeltaLibrary} from "v4-core/types/BeforeSwapDelta.sol";

/// @title WhitelistHook
/// @notice A hook that restricts swaps to whitelisted addresses
/// @dev Demonstrates access control in hooks
contract WhitelistHook is BaseHook {
    /// @notice Emitted when an address is added to the whitelist
    event AddressWhitelisted(address indexed account);
    
    /// @notice Emitted when an address is removed from the whitelist
    event AddressRemovedFromWhitelist(address indexed account);

    /// @notice Mapping to track whitelisted addresses
    mapping(address => bool) public whitelist;
    
    /// @notice Owner address for access control
    address public owner;

    error NotWhitelisted();
    error OnlyOwner();

    modifier onlyOwner() {
        if (msg.sender != owner) revert OnlyOwner();
        _;
    }

    constructor(IPoolManager _poolManager) BaseHook(_poolManager) {
        owner = msg.sender;
    }

    /// @notice Returns the hook's permissions
    function getHookPermissions() public pure override returns (Hooks.Permissions memory) {
        return Hooks.Permissions({
            beforeInitialize: false,
            afterInitialize: false,
            beforeAddLiquidity: false,
            afterAddLiquidity: false,
            beforeRemoveLiquidity: false,
            afterRemoveLiquidity: false,
            beforeSwap: true,
            afterSwap: false,
            beforeDonate: false,
            afterDonate: false,
            beforeSwapReturnDelta: false,
            afterSwapReturnDelta: false,
            afterAddLiquidityReturnDelta: false,
            afterRemoveLiquidityReturnDelta: false
        });
    }

    /// @notice Add an address to the whitelist
    /// @param account The address to whitelist
    function addToWhitelist(address account) external onlyOwner {
        whitelist[account] = true;
        emit AddressWhitelisted(account);
    }

    /// @notice Remove an address from the whitelist
    /// @param account The address to remove
    function removeFromWhitelist(address account) external onlyOwner {
        whitelist[account] = false;
        emit AddressRemovedFromWhitelist(account);
    }

    /// @notice Hook called before a swap - checks if sender is whitelisted
    function beforeSwap(
        address sender,
        PoolKey calldata key,
        IPoolManager.SwapParams calldata params,
        bytes calldata hookData
    ) external override onlyPoolManager returns (bytes4, BeforeSwapDelta, uint24) {
        // Check if sender is whitelisted
        if (!whitelist[sender]) {
            revert NotWhitelisted();
        }
        
        return (this.beforeSwap.selector, BeforeSwapDeltaLibrary.ZERO_DELTA, 0);
    }
}
