pragma solidity ^0.4.8;
import "./MiniMeToken.sol";

contract CardTokenController is TokenController {

    MiniMeToken ProjectToken;   // The new card token
    //MiniMeToken CardToken;   // The new card token

    address public allowedSupplier; // the supplier that can claim the card

    address supplier; // the supplier that has actually claimed the card.

    address owner;

    CardStatuses public cardstatus;

   enum CardStatuses {
        Open,
        Claimed,
        Approved,
        Rejected
        //Finished
    }

    function CardTokenController(
        address _ProjectTokenaddress,
        //address _CardTokenaddress,          // the new MiniMe token address
        address _owner
    ) {
        //CardToken = MiniMeToken(_CardTokenaddress); // The Deployed Token Contract
        ProjectToken = MiniMeToken(_ProjectTokenaddress);
        owner = _owner;
        cardstatus = CardStatuses.Open;
    }

/////////////////
// TokenController interface
/////////////////


    function proxyPayment(address _owner) payable returns(bool) {
        return false;
    }

    function onTransfer(address _from, address _to, uint _amount) returns(bool) {

      // we're paying out ?
      if (_to == address(ProjectToken)){
        //CardToken.destroyTokens(msg.sender,_amount);
        //ProjectToken.generateTokens(msg.sender,_amount);
        if (!supplier.send(_amount)){
          throw;
        }
        cardstatus = CardStatuses.Approved;
        CardApproved(this,supplier,_amount);

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

      allowedSupplier = _supplier;
    }

    // sending ETH mints card-tokens
    function() payable {

      // when supplier is set - minting new tokens is disabled. ETH is sent back.
      if (supplier != 0x0){
        throw;
      }

      //CardToken.generateTokens(msg.sender, msg.value);

    }

    event CardClaimed(address cardcontroller, address supplier);
    event CardApproved(address cardcontroller,address supplier,uint amount);
    event CardRejected(address cardcontroller, address supplier);

    function claim(){

      // has it been claimed already ?
      if (supplier != 0x0){
        throw;
      }

      // am I the correct claimer ?
      if (msg.sender != allowedSupplier){
        throw;
      }

      supplier = msg.sender;

      cardstatus = CardStatuses.Claimed;

      CardClaimed(this,msg.sender);

    }

    function approve(){ // payout and approve

     if (msg.sender != owner){
        throw;
      }

      //supplier.send(this.value);

      // generate Project tokens for the funder ( == the owner for now )
      //ProjectToken.generateTokens(owner, this.value);

    }

    // function panic() {  // cancel and send money back
    //   selfdestruct(_boardowner);
    // }

    function fuckYou(){ // I don't approve this - remove supplier, so that he is fucked

      // only the owner can fuck over the supplier
      if (msg.sender != owner){
        throw;
      }

      CardRejected(this,supplier);

      supplier = 0;
      allowedSupplier = 0;
      cardstatus = CardStatuses.Open;
    }
}
