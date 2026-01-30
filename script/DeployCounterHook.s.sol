// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {IPoolManager} from "v4-core/interfaces/IPoolManager.sol";
import {CounterHook} from "../src/CounterHook.sol";

/// @notice Deployment script for CounterHook
/// @dev WARNING: This script uses CREATE which does not guarantee the hook address
///      will match the required prefix based on hook permissions. In production,
///      you should use CREATE2 with proper address mining to deploy hooks at
///      addresses that satisfy the hook permission requirements.
///      See: https://github.com/Uniswap/v4-periphery for examples.
contract DeployCounterHook is Script {
    function run() external {
        // Load deployer private key from environment
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        // Get pool manager address (this should be the deployed v4 PoolManager)
        address poolManager = vm.envAddress("POOL_MANAGER_ADDRESS");
        
        vm.startBroadcast(deployerPrivateKey);
        
        // Deploy the CounterHook
        CounterHook hook = new CounterHook(IPoolManager(poolManager));
        
        console.log("CounterHook deployed at:", address(hook));
        
        vm.stopBroadcast();
    }
}
