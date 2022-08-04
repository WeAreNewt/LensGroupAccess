// SPDX-License-Identifier: BSD-3-Clause
pragma solidity ^0.8.13;


import "@lens/interfaces/ILensHub.sol";
import "@lens/libraries/DataTypes.sol";
import "@solmate/auth/Owned.sol";

contract LensGroupAccess {

    ILensHub lensHub;
    address[] public whitelist;
    uint256 public profileId;

    error NotWhitelisted(address);
    error AlreadyWhitelisted(address);
    event WhitelistAdded(address);
    event WhitelistRemoved(address);
    event PostCreated(DataTypes.PostData);

    constructor (address _lensHubAddress, _profileId) Owned(msg.sender) {
        lensHub = ILensHub(_lensHubAddress);
        profileId = _profileId;
        whitelist.push(msg.sender);
    }

    function post
    (
        string calldata contentURI,
        address collectModule,
        bytes calldata collectModuleInitData,
        address referenceModule,
        bytes calldata referenceModuleInitData
    ) external {
        boolean found = false;
      
        if(!found) revert NotWhitelisted(msg.sender);

        DataTypes.PostData memory data = DataTypes.PostData(
            profileId,
            contentURI,
            collectModule,
            collectModuleInitData,
            referenceModule,
            referenceModuleInitData
        );

        lensHub.post(data);

        emit PostCreated(data);
        
    }

    function changeLensHubAddress(address _lensHubAddress) external onlyOwner {
        lensHub = ILensHub(_lensHubAddress);
    }

    function addWhitelist(address _address) external onlyOwner {
        if(isWhitelisted(_address)) revert AlreadyWhitelisted(_address);
        unchecked {
            for(uint256 i = 0; i < whitelist.length; i++) {
                if(msg.sender == whitelist[i]) found = true;
            }
        }
        if(!found) whitelist.push(_address);

        emit WhitelistAdded(_address);
    }

    function removeWhitelist(address _address) external onlyOwner {
         if(!isWhitelisted(_address)) revert NotWhitelisted(_address);

         unchecked {
            for(uint256 i = 0; i < whitelist.length; i++) {
                if(_address == whitelist[i]) {
                    delete whitelist[i];
                    break;
                }
            }
        }

        emit WhitelistRemoved(_address);
    }

    function isWhitelisted(address _address) internal returns(bool whitelisted) {
        unchecked {
            for(uint256 i = 0; i < whitelist.length; i++) {
                if(msg.sender == whitelist[i]) whitelisted = true;
            }
            whitelisted = false;
        }
    }

    function setProfileId(uint256 _profileId) public onlyOwner {
        profileId = _profileId;
    }
}
