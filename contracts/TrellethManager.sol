pragma solidity ^0.4.8;

import "./MiniMeToken.sol";
import "./ProjectTokenController.sol";
//import "./CardTokenController.sol";



contract TrellethManager {

    struct board {
        address boardowner;
        address Projecttoken;
    }

    mapping(string=>board) Projects;     // Trello Board ID -> board struct

    mapping(address=>mapping(address=>uint)) myProjects; // my pubkey to Projects

    mapping(string=>address) cardtoProjects; // maps a cardID to it's token address

    event NewProject(address sender, address newToken);
    event TrellEthed(string cardID, address TrellethCardToken);

    event Log(string bla);

    address tokenFactory;

	function TrellethManager(address _tokenFactory){
        tokenFactory = _tokenFactory;

	}

     mapping(string=>address) boardToProject;   // mapping from board ID to Project address

     // manage a new Project
     function makeProject(string _tokenshortcode, string _tokenname){

        Log('1');

        // deploy Project token
        MiniMeToken newProjectToken = new MiniMeToken(
            tokenFactory,
            0,
            0,
            _tokenname,
            0,
            _tokenshortcode,
            true
            );
        Log('2');

        ProjectTokenController tk = new ProjectTokenController(newProjectToken);

        newProjectToken.changeController(tk);

        // add this Project Token to this user's list of Project tokens
        myProjects[msg.sender][address(newProjectToken)]=1;        

        // notify user
        NewProject(msg.sender,address(newProjectToken));  
     }

     // attach a board to the Project token
     function attachBoard(address _Projecttoken, string _boardID){
        
        // If this Project Token is not mine, I cannot add a board to it.
        if (myProjects[msg.sender][address(_Projecttoken)] != 1){
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

   		MiniMeToken newToken = new MiniMeToken(
            tokenFactory,
            0,
            0,
            _trelloCardId,
            0,
            'TTOK',
            true
            );

        //TODO : uncomment me
        //CardTokenController tcc = new CardTokenController(boardToProject[_trelloBoardID],newToken);
        //newToken.changeController(tcc);

        cardtoProjects[_trelloCardId] = address(newToken);

        // notify UI sothat you know that a new token has been deployed for this card
        TrellEthed(_trelloCardId,newToken);

	 }

}
