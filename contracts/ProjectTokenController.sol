pragma solidity ^0.4.8;
import "./MiniMeToken.sol";
contract ProjectTokenController is TokenController {

    address ProjectTokenContract;   // The new Project token

    function ProjectTokenController(
        //string _ProjectTokenName          // the new MiniMe token address
    ) {

 //        ProjectTokenContract = 
 // new MiniMeToken(
 //    //         miniMeTokenFactory.address,
 //    //         0,
 //    //         0,
 //    //         "My project Token",
 //    //         0,
 //    //         "MYPTOK",
 //    //         true
 //        _ProjectTokenAddress; // The Deployed Token Contract
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


