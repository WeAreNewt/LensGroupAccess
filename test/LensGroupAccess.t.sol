// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "@lens/libraries/DataTypes.sol";
import "forge-std/console2.sol";
import '../src/LensGroupAccess.sol';


contract LensGroupAccessTest is Test {
    uint256 public constant PROFILE_ID = 1408;
    LensGroupAccess lensGroupAccess;

    ILensHub lensHub = ILensHub(0xDb46d1Dc155634FbC732f92E853b10B288AD5a1d);

    address addressWithDAOProfile = 0x14306f86629E6bc885375a1f81611a4208316B2b;
    address nftOwner = 0x7020AFb73882c715415810Cfe12946bf1f999a9b;
    address user = address(3);

    function setUp() public {
        lensGroupAccess = new LensGroupAccess(0xDb46d1Dc155634FbC732f92E853b10B288AD5a1d, PROFILE_ID);
        vm.prank(addressWithDAOProfile);
        lensHub.setDispatcher(PROFILE_ID, address(lensGroupAccess));
    }

    function testAddWhitelist() public {
        lensGroupAccess.addWhitelist(user);
        bool whitelisted = lensGroupAccess.isWhitelisted(user);
        assertEq(whitelisted, true);
    }

    function testRemoveWhitelist() public {
        bool whitelisted;
        lensGroupAccess.addWhitelist(user);
        whitelisted = lensGroupAccess.isWhitelisted(user);
        assertEq(whitelisted, true);
    }

    function testRemoveWhitelistIfNotInWhitelist() public {
        vm.expectRevert(abi.encodeWithSignature("NotWhitelisted()"));
        lensGroupAccess.removeWhitelist(user);
    }

    function testAddWhitelistIfAlreadyInWhitelist() public {
        lensGroupAccess.addWhitelist(user);
        vm.expectRevert(abi.encodeWithSignature("AlreadyWhitelisted()"));
        lensGroupAccess.addWhitelist(user);
    }


    function testPostIfWhitelisted() public {
        DataTypes.ProfileStruct memory profile =  lensHub.getProfile(PROFILE_ID);

        lensGroupAccess.addWhitelist(user);
        bool whitelisted = lensGroupAccess.isWhitelisted(user);
        assertEq(whitelisted, true);

        vm.prank(user);

        lensGroupAccess.post(
            'aave.com', 
            0x23b9467334bEb345aAa6fd1545538F3d54436e96, // test module, everyone can collect
            abi.encode(false), 
            address(0), 
            abi.encode('')
        );

        assertEq(lensHub.getContentURI(PROFILE_ID, profile.pubCount+1), 'aave.com');
    }

    function testPostIfNotWhitelisted() public {
        vm.prank(user);
        vm.expectRevert(abi.encodeWithSignature("NotWhitelisted()"));
        lensGroupAccess.post(
            'aave.com', 
            0x23b9467334bEb345aAa6fd1545538F3d54436e96, // test module, everyone can collect
            abi.encode(false), 
            address(0), 
            abi.encode('')
        );
    }

    function testSetProfileId() public {
        uint256 dummyProfileId = 10;
        lensGroupAccess.setProfileId(dummyProfileId);
        assertEq(dummyProfileId, lensGroupAccess.profileId());
    }
}
