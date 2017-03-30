pragma solidity ^0.4.8;

/*
  MiniMeToken contract taken from https://github.com/Giveth/minime/
 */

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
  function mintToken(uint amount);
  function setChiefApricot(string _boardID,address _boardowner);
}



// Taken from Zeppelin's standard contracts.
contract ERC20 {
  uint public totalSupply;
  function balanceOf(address who) constant returns (uint);
  function allowance(address owner, address spender) constant returns (uint);

  function transfer(address to, uint value) returns (bool ok);
  function transferFrom(address from, address to, uint value) returns (bool ok);
  function approve(address spender, uint value) returns (bool ok);
  event Transfer(address indexed from, address indexed to, uint value);
  event Approval(address indexed owner, address indexed spender, uint value);
}

contract TrellethTokenController is TokenController {

    MiniMeToken public ICOToken;   // The new token

    address public _allowedsupplier;

    address supplier;

    string _cardID;

    address owner;

    uint cardstatus;

    function TrellethTokenController(
        address _ICOtokenaddress,
        address _tokenAddress          // the new MiniMe token address
    ) {
        tokenContract = MiniMeToken(_tokenAddress); // The Deployed Token Contract
        ICOToken = new MiniMeToken(_ICOtokenaddress);
        owner = msg.sender;
        cardstatus = 1;
    }

/////////////////
// TokenController interface
/////////////////


    function proxyPayment(address _owner) payable returns(bool) {
        return false;
    }

    function onTransfer(address _from, address _to, uint _amount) returns(bool) {

      // we're paying out ?
      if (_to == ICOToken.address){
        //tokenContract.destroyTokens(msg.sender,_amount);
        ICOToken.generateTokens(msg.sender,_amount);
        supplier.send(_amount);
        cardstatus = 2;
      }

        return true;
    }

    function onApprove(address _owner, address _spender, uint _amount) returns(bool)
    {
        return false;
    }

    function assignSupplier(address _supplier) {

      if (msg.sender != owner){
        throw;
      }

      this._allowedsupplier = _supplier;
    }

    // sending ETH mints card-tokens
    function() payable {

      // when supplier is set - minting new tokens is disabled. ETH is sent back.
      if (supplier){
        throw;
      }

      tokenContract.generateTokens(msg.sender, msg.value);

    }

    event CardClaimed(address cardcontroller, address supplier);

    function claim(){

      // has it been claimed already ?
      if (supplier){
        throw;
      }

      // am I the correct claimer ?
      if (msg.sender != _allowedsupplier){
        throw;
      }

      supplier = msg.sender;

      CardClaimed(this,msg.sender);

    }

    // function resolve(){ // payout and approve

    //  if (msg.sender != owner){
    //     throw;
    //   }

    //   supplier.send(this.value);

    //   // generate ICO tokens for the funder ( == the owner for now )
    //   ICOToken.generateTokens(owner, this.value);

    // }

    // function panic() {  // cancel and send money back
    //   selfdestruct(_boardowner);
    // }

    function fuckYou(){ // I don't approve this - remove supplier, so that he is fucked

      // only the owner can fuck over the supplier
      if (msg.sender != owner){
        throw;
      }

      this.supplier = 0;
      this._allowedsupplier = 0;
    }

//    function convert(uint _amount){

        // transfer ARC to the vault address. caller needs to have an allowance from
        // this controller contract for _amount before calling this or the transferFrom will fail.
//        if (!arcToken.transferFrom(msg.sender, 0x0, _amount)) {
//            throw;
//        }

        // mint new SWT tokens
//        if (!tokenContract.generateTokens(msg.sender, _amount)) {
//            throw;
//        }
//    }


}