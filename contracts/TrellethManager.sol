pragma solidity ^0.4.6;

contract MiniMeTokenFactory {
    function createCloneToken(
        address _parentToken,
        uint _snapshotBlock,
        string _tokenName,
        uint8 _decimalUnits,
        string _tokenSymbol,
        bool _transfersEnabled
    )returns (address);
}

contract MiniMeToken {

}



contract TrellethManager {

    struct board {
        address boardowner;
        address icotoken;
    }

    mapping(string=>board) public icos;     // Trello Board ID -> board struct

    mapping(address=>address[]) public myicos; // my pubkey to ICOs

    mapping(string=>address) public cardtoicos; // maps a cardID to it's token address

    event NewIco(address sender, address newToken);
    event TrellEthed(string cardID, address TrellethCardToken);

    address tokenFactory;

	function TrellethManager(address _tokenFactory){
        tokenFactory = _tokenFactory;

	}

     mapping(string=>address) public boardToICO;   // mapping from board ID to ICO address

     // manage a new ICO
     function makeICO(string _tokenshortcode, string _tokenname){

        // deploy ICO token
        MiniMeToken newToken = new MiniMeToken(
            tokenFactory,
            0,
            0,
            _tokenname,
            0,
            _tokenshortcode,
            true
            );

        ICOTokenController tk = new ICOTokenController(_ICOtoken.controller);

        newToken.changeController(tk.address);

        myicos[msg.sender].push(newToken.address);        

        // notify user
        NewIco(msg.sender,newToken.address);  
     }

     // attach a board to the ICO token
     function attachBoard(address _ICOtoken, string _boardID){
        
        if (!myicos[msg.sender][_ICOtoken]){
            throw;
        }

        boardToICO[_boardID] = ICOtoken;

     }

     // TrellEth a card
	 function trellethIt(string _trelloCardId,string _trelloBoardID) {

        // is this board attached to an ICO ?
        if (!boardToICO[_trelloBoardID]){
            throw;
        }

        // is the message sender the owner of this ICO ? 
        // otherwise everybody can attach cards to any ICO - and thatwilleweniet
        if (!myicos[msg.sender][boardToICO[_trelloBoardID]]){
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

        TrellethCardController tcc = new TrellethCardController(boardToICO[_trelloBoardID],newToken.address);

        newToken.changeController(tcc.address);

        cardtoicos[_trelloCardId] = newToken.address;

        // notify UI sothat you know that a new token has been deployed for this card
        TrellEthed(_trelloCardId,newToken.address);

	 }

}
