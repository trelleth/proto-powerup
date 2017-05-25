pragma solidity ^0.4.8;
import "./MiniMeToken.sol";
import "./IMiniMeToken.sol";
import "./CardTokenController.sol";

contract CardTokenControllerFactory {

  MiniMeTokenFactory tokenFactory;

  function CardTokenControllerFactory(address _tokenFactory){
    tokenFactory = MiniMeTokenFactory(_tokenFactory);
  //  trellethToken = MiniMeToken(_trellethToken);
  }

 function makeCardToken(string _cardTokenName,address _projectToken) returns(address) {

        MiniMeToken _cardToken = new MiniMeToken(
            tokenFactory,
            0,
            0,
            _cardTokenName,
            0,
            '',
            true
            );

         CardTokenController tk = new CardTokenController(msg.sender,_projectToken);
         _cardToken.changeController(tk);

         return address(_cardToken);
   
    }


}
