// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "@lens/libraries/DataTypes.sol";
import "forge-std/console2.sol";
import '../src/LensGroupAccess.sol';


contract LensGroupAccessTest is Test {
    uint256 public constant PROFILE_ID = 1408;
    LensGroupAccess private lensGroupAccess;

    ILensHub lensHub = ILensHub(0xDb46d1Dc155634FbC732f92E853b10B288AD5a1d);

    address addressWithDAOProfile = 0x14306f86629E6bc885375a1f81611a4208316B2b;
    address nftOwner = 0x7020AFb73882c715415810Cfe12946bf1f999a9b;

    function setUp(
        lensGroupAccess = new LensGroupAccess(0xDb46d1Dc155634FbC732f92E853b10B288AD5a1d, PROFILE_ID);
        vm.prank(addressWithDAOProfile);
        lensHub.setDispatcher(PROFILE_ID, address(postDAO));
    ) public {}

    function testExample() public {
        assertTrue(true);
    }
}
