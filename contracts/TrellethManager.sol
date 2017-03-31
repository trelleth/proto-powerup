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


contract Controlled {
    /// @notice The address of the controller is the only address that can call
    ///  a function with this modifier
    modifier onlyController { if (msg.sender != controller) throw; _; }

    address public controller;

    function Controlled() { controller = msg.sender;}

    /// @notice Changes the controller of the contract
    /// @param _newController The new controller of the contract
    function changeController(address _newController) onlyController {
        controller = _newController;
    }
}


contract MiniMeToken is Controlled{
    string public name;                //The Token's name: e.g. DigixDAO Tokens
    uint8 public decimals;             //Number of decimals of the smallest unit
    string public symbol;              //An identifier: e.g. REP
    string public version = 'MMT_0.1'; //An arbitrary versioning scheme


    /// @dev `Checkpoint` is the structure that attaches a block number to a
    ///  given value, the block number attached is the one that last changed the
    ///  value
    struct  Checkpoint {

        // `fromBlock` is the block number that the value was generated from
        uint128 fromBlock;

        // `value` is the amount of tokens at a specific block number
        uint128 value;
    }

    // `parentToken` is the Token address that was cloned to produce this token;
    //  it will be 0x0 for a token that was not cloned
    MiniMeToken public parentToken;

    // `parentSnapShotBlock` is the block number from the Parent Token that was
    //  used to determine the initial distribution of the Clone Token
    uint public parentSnapShotBlock;

    // `creationBlock` is the block number that the Clone Token was created
    uint public creationBlock;

    // `balances` is the map that tracks the balance of each address, in this
    //  contract when the balance changes the block number that the change
    //  occurred is also included in the map
    mapping (address => Checkpoint[]) balances;

    // `allowed` tracks any extra transfer rights as in all ERC20 tokens
    mapping (address => mapping (address => uint256)) allowed;

    // Tracks the history of the `totalSupply` of the token
    Checkpoint[] totalSupplyHistory;

    // Flag that determines if the token is transferable or not.
    bool public transfersEnabled;

    // The factory used to create new clone tokens
    MiniMeTokenFactory public tokenFactory;

////////////////
// Constructor
////////////////

    /// @notice Constructor to create a MiniMeToken
    /// @param _tokenFactory The address of the MiniMeTokenFactory contract that
    ///  will create the Clone token contracts, the token factory needs to be
    ///  deployed first
    /// @param _parentToken Address of the parent token, set to 0x0 if it is a
    ///  new token
    /// @param _parentSnapShotBlock Block of the parent token that will
    ///  determine the initial distribution of the clone token, set to 0 if it
    ///  is a new token
    /// @param _tokenName Name of the new token
    /// @param _decimalUnits Number of decimals of the new token
    /// @param _tokenSymbol Token Symbol for the new token
    /// @param _transfersEnabled If true, tokens will be able to be transferred
    function MiniMeToken(
        address _tokenFactory,
        address _parentToken,
        uint _parentSnapShotBlock,
        string _tokenName,
        uint8 _decimalUnits,
        string _tokenSymbol,
        bool _transfersEnabled
    ) {
        tokenFactory = MiniMeTokenFactory(_tokenFactory);
        name = _tokenName;                                 // Set the name
        decimals = _decimalUnits;                          // Set the decimals
        symbol = _tokenSymbol;                             // Set the symbol
        parentToken = MiniMeToken(_parentToken);
        parentSnapShotBlock = _parentSnapShotBlock;
        transfersEnabled = _transfersEnabled;
        creationBlock = block.number;
    }



}

// TokenController interface
contract TokenController {
    function proxyPayment(address _owner) payable returns(bool);
    function onTransfer(address _from, address _to, uint _amount) returns(bool);
    function onApprove(address _owner, address _spender, uint _amount) returns(bool);
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


contract CardTokenController is TokenController {

    MiniMeToken ICOToken;   // The new card token
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
        address _ICOTokenaddress,
        address _CardTokenaddress          // the new MiniMe token address
    ) {
        CardToken = MiniMeToken(_CardTokenaddress); // The Deployed Token Contract
        ICOToken = MiniMeToken(_ICOTokenaddress);
        owner = msg.sender;
        cardstatus = CardStatuses.Open;
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



contract TrellethManager {

    struct board {
        address boardowner;
        address icotoken;
    }

    mapping(string=>board) public icos;     // Trello Board ID -> board struct

    mapping(address=>mapping(address=>uint)) public myicos; // my pubkey to ICOs

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
        MiniMeToken newICOToken = new MiniMeToken(
            tokenFactory,
            0,
            0,
            _tokenname,
            0,
            _tokenshortcode,
            true
            );

        ICOTokenController tk = new ICOTokenController(newICOToken);

        newICOToken.changeController(tk);

        // add this ICO Token to this user's list of ICO tokens
        myicos[msg.sender][address(newICOToken)]=1;        

        // notify user
        NewIco(msg.sender,address(newICOToken));  
     }

     // attach a board to the ICO token
     function attachBoard(address _ICOtoken, string _boardID){
        
        // If this ICO Token is not mine, I cannot add a board to it.
        if (myicos[msg.sender][address(_ICOtoken)] != 1){
            throw;
        }

        boardToICO[_boardID] = address(_ICOtoken);

     }

     // TrellEth a card
	 function trellethIt(string _trelloCardId,string _trelloBoardID) {

        // is this board attached to an ICO ?
        if (boardToICO[_trelloBoardID] == 0x0){
            throw;
        }

        // is the message sender the owner of this ICO ? 
        // otherwise everybody can attach cards to any ICO - and thatwilleweniet
        if (myicos[msg.sender][boardToICO[_trelloBoardID]] != 1){
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

        CardTokenController tcc = new CardTokenController(boardToICO[_trelloBoardID],newToken);

        newToken.changeController(tcc);

        cardtoicos[_trelloCardId] = address(newToken);

        // notify UI sothat you know that a new token has been deployed for this card
        TrellEthed(_trelloCardId,newToken);

	 }

}
