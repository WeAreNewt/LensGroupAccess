// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "forge-std/Script.sol";
import "../src/LensGroupAccess.sol";

/*
    Deploys and sends a post with the test metadata if testPost = true
*/
contract Deploy is Script {

    uint256 constant PROFILE_ID = 17046;
    LensGroupAccess private lensGroupAcces;

    ILensHub lensHub = ILensHub(0x60Ae865ee4C725cd04353b5AAb364553f56ceF82);

    function run() external {
        vm.startBroadcast();

        lensGroupAcces = new LensGroupAccess(0x60Ae865ee4C725cd04353b5AAb364553f56ceF82);
        lensHub.setDispatcher(PROFILE_ID, address(postDAO));

        vm.stopBroadcast();
    }
}