pragma solidity ^0.4.8;
import "./IMiniMeToken.sol";
import "./IProjectTokenControllerFactory.sol";
import "./ICardTokenControllerFactory.sol";

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

    event NewProject(address sender, address projectToken);
    event TrellEthed(string cardID, address cardToken);

    IProjectTokenControllerFactory public projectTokenFactory;
    ICardTokenControllerFactory public cardTokenFactory;
  
	function TrellethManager(){
	}

    function setFactories(IProjectTokenControllerFactory _projectTokenFactory,ICardTokenControllerFactory _cardTokenFactory){
        projectTokenFactory = _projectTokenFactory; //_projectTokenFactory);
        cardTokenFactory = _cardTokenFactory; //_cardTokenFactory);
        //projectTokenFactory.makeProjectToken("test");
    }

    function getBoardAddress(string _boardID) returns (address){
        return(boardToProject[_boardID]);
    }


     // manage a new Project
     function makeProject(string _projectTokenName){


NewProject(msg.sender,projectTokenFactory);
return;
//        if (address(projectTokenFactory))

        //IMiniMeToken _projectToken = IMiniMeToken(0x0); //projectTokenFactory.makeProjectToken(_projectTokenName);
projectTokenFactory.test();
address _projectToken = 0x0;
        // MiniMeToken _projectToken = new MiniMeToken(
        //     trellethFactory,
        //     0,
        //     0,
        //     _projectTokenName,
        //     0,
        //     _tokenshortcode,
        //     true
        //     );

        //  IProjectTokenController tk = IProjectTokenController(_projectTokenControllerAddress);
        //  _projectToken.changeController(tk);

        // add this Project Token to this user's list of Project tokens
        myProjects[msg.sender][_projectToken]=1;        
        myProjectsCounts[msg.sender]++;

        // track the owner of a project token
        projectOwner[_projectToken] = msg.sender;

        // notify user
        NewProject(msg.sender,_projectToken);  
//         NewProject(msg.sender,address(_projectToken),address(0));  
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

//        MiniMeToken cardToken = MiniMeToken(_cardTokenAddress);

IMiniMeToken cardToken = IMiniMeToken(cardTokenFactory.makeCardToken(_trelloCardId,boardToProject[_trelloBoardID]));

//  MiniMeToken cardToken;
         // MiniMeToken cardToken = new MiniMeToken(
         //    f,
         //    0,
         //    0,
         //    _trelloCardId,
         //    0,
         //    "TCTOK",
         //    true
         //    );
//      //    //TODO : uncomment me
// //    ICardTokenController tcc = ICardTokenController(_cardTokenControllerAddress);

//          CardTokenController tcc = new CardTokenController(boardToProject[_trelloBoardID],cardToken,msg.sender);
//          cardToken.changeController(tcc);

        cardtoProjects[_trelloCardId] = cardToken;

         // notify UI sothat you know that a new token has been deployed for this card
        TrellEthed(_trelloCardId,cardToken);

	 }

}
