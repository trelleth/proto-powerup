pragma solidity ^0.4.8;
import "./MiniMeToken.sol";
//import "./MiniMeToken.sol";
//import "./ProjectTokenController.sol";
//import "./CardTokenController.sol";
// contract MiniMeTokenFactory {
//         function createCloneToken(
//         address _parentToken,
//         uint _snapshotBlock,
//         string _tokenName,
//         uint8 _decimalUnits,
//         string _tokenSymbol,
//         bool _transfersEnabled
//     ) returns (address);
// }

// contract Controlled {
//     /// @notice The address of the controller is the only address that can call
//     ///  a function with this modifier
//     modifier onlyController { if (msg.sender != controller) throw; _; }

//     address public controller;

//     function Controlled() { controller = msg.sender;}

//     /// @notice Changes the controller of the contract
//     /// @param _newController The new controller of the contract
//     function changeController(address _newController) onlyController {
//         controller = _newController;
//     }
// }

// contract MiniMeToken {
//     function changeController(address _newController);
// }

// contract TokenController {
//     function proxyPayment(address _owner) payable returns(bool);
//     function onTransfer(address _from, address _to, uint _amount) returns(bool);
//     function onApprove(address _owner, address _spender, uint _amount) returns(bool);
// }

contract ProjectTokenController is TokenController {

    address ProjectTokenContract;   // The new Project token

    function ProjectTokenController(
        address _ProjectTokenAddress          // the new MiniMe token address
    ) {
        ProjectTokenContract = _ProjectTokenAddress; // The Deployed Token Contract
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



contract CardTokenController is TokenController {

    MiniMeToken ProjectToken;   // The new card token
    MiniMeToken CardToken;   // The new card token

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
        address _CardTokenaddress,          // the new MiniMe token address
        address _owner
    ) {
        CardToken = MiniMeToken(_CardTokenaddress); // The Deployed Token Contract
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

contract TrellethManager {


    struct board {
        address boardowner;
        address Projecttoken;
    }

    mapping(string=>board) Projects;     // Trello Board ID -> board struct

    mapping(address=>mapping(address=>uint)) public myProjects; // my pubkey to Projects
    mapping(address=>address) public projectOwner;
    mapping(address=>uint) public myProjectsCounts;

    mapping(string=>address) cardtoProjects; // maps a cardID to it's token address

    mapping(string=>address) boardToProject;   // mapping from board ID to Project token address

    event NewProject(address sender, address projectToken,address projectTokenController);
    event TrellEthed(string cardID, address cardToken, address cardTokenController);

    MiniMeTokenFactory tokenFactory;
  

	function TrellethManager(address _tokenFactory){
        tokenFactory = MiniMeTokenFactory(_tokenFactory);
       
	}

    function getBoardAddress(string _boardID) returns (address){
        return(boardToProject[_boardID]);
    }


     // manage a new Project
     function makeProject(string _tokenname,string _tokenshortcode){

        MiniMeToken newProjectToken = new MiniMeToken(
            tokenFactory,
            0,
            0,
            _tokenname,
            0,
            _tokenshortcode,
            true
            );

        ProjectTokenController tk = new ProjectTokenController(address(newProjectToken));
        newProjectToken.changeController(address(tk));

        // add this Project Token to this user's list of Project tokens
        myProjects[msg.sender][address(newProjectToken)]=1;        
        myProjectsCounts[msg.sender]++;

        // track the owner of a project token
        projectOwner[newProjectToken] = msg.sender;

//         // notify user
        NewProject(msg.sender,address(newProjectToken),address(tk));  
//         NewProject(msg.sender,address(newProjectToken),address(0));  
     }

     // attach a board to the Project token
     function attachBoard(address _Projecttoken, string _boardID){
        
        // If this Project Token is not mine, I cannot add a board to it.
        if (myProjects[msg.sender][address(_Projecttoken)] != 1){
            throw;
        }
        // you cannot overwrite the ownership of an assigned board
        if (boardToProject[_boardID] != 0x0){
            throw;
        }

        boardToProject[_boardID] = address(_Projecttoken);

     }

     // TrellEth a card
	 function trellethIt(string _trelloCardId,string _trelloBoardID) {

        // is this board attached to an Project ?
        if (boardToProject[_trelloBoardID] == 0x0){
            throw;
        }

        // is the message sender the owner of this Project ? 
        // otherwise everybody can attach cards to any Project - and thatwilleweniet
        if (myProjects[msg.sender][boardToProject[_trelloBoardID]] != 1){
            throw;
        }
MiniMeToken cardToken;
        //  cardToken = new MiniMeToken(
        //     tokenFactory,
        //     0,
        //     0,
        //     _trelloCardId,
        //     0,
        //     "TCTOK",
        //     true
        //     );
     //    //TODO : uncomment me
         CardTokenController tcc = new CardTokenController(boardToProject[_trelloBoardID],cardToken,msg.sender);
         //cardToken.changeController(tcc);

         cardtoProjects[_trelloCardId] = cardToken;

         // notify UI sothat you know that a new token has been deployed for this card
         TrellEthed(_trelloCardId,cardToken,tcc);
//         TrellEthed(_trelloCardId,0x0);

	 }

}
