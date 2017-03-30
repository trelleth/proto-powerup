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
	
	//mapping(string=>address) boardowners;

	//string[] boards;

	function mintToken(uint amount){
		//
	}

	// function setChiefApricot(string _boardID,address _boardowner){
	// 	if (boardowners[_boardID]){
	// 		throw;
	// 	}
	// 	boardowners[_boardID] = _boardowner;
	// 	boards.push(_boardowner);
	// }

}