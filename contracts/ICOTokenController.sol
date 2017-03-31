pragma solidity ^0.4.8;

// TokenController interface
contract TokenController {
    function proxyPayment(address _owner) payable returns(bool);
    function onTransfer(address _from, address _to, uint _amount) returns(bool);
    function onApprove(address _owner, address _spender, uint _amount) returns(bool);
}

// Minime interface
contract MiniMeToken {
    function generateTokens(address _owner, uint _amount
    ) returns (bool);
}

contract ICOTokenController is TokenController {


    MiniMeToken public ICOTokenContract;   // The new ICO token

    function ICOTokenController(
        address _ICOTokenAddress          // the new MiniMe token address
    ) {
        ICOTokenContract = MiniMeToken(_ICOTokenAddress); // The Deployed Token Contract
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