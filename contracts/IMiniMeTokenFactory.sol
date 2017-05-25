pragma solidity ^0.4.8;

import './IMiniMeToken.sol';

contract IMiniMeTokenFactory {
	 function createCloneToken(
        address _parentToken,
        uint _snapshotBlock,
        string _tokenName,
        uint8 _decimalUnits,
        string _tokenSymbol,
        bool _transfersEnabled
    ) returns (IMiniMeToken);

}