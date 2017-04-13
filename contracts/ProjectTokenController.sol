pragma solidity ^0.4.8;

import "./MiniMeToken.sol";

contract ProjectTokenController is TokenController {


    MiniMeToken ProjectTokenContract;   // The new Project token

    function ProjectTokenController(
        address _ProjectTokenAddress          // the new MiniMe token address
    ) {
        ProjectTokenContract = MiniMeToken(_ProjectTokenAddress); // The Deployed Token Contract
    }

	 function proxyPayment(address _owner) payable returns(bool) {
        return false;
    }

    function onTransfer(address _from, address _to, uint _amount) returns(bool) {
        return true;
    }

    function onApprove(address _owner, address _spender, uint _amount)
        returns(bool)
    {
        return true;
    }

}