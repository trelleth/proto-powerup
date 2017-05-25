pragma solidity ^0.4.8;
import "./MiniMeToken.sol";
import "./IMiniMeToken.sol";
import "./ProjectTokenController.sol";
contract ProjectTokenControllerFactory{


    //MiniMeToken trellethToken;
    MiniMeTokenFactory tokenFactory;
    string name;

    function ProjectTokenControllerFactory(address _tokenFactory){
        tokenFactory = MiniMeTokenFactory(_tokenFactory);
    //  trellethToken = MiniMeToken(_trellethToken);
    }


    function test(){
        //name = 'test';
    }

  function makeProjectToken(string _projectTokenName) returns(IMiniMeToken) {

    //MiniMeToken _projectToken = tokenFactory.createCloneToken(trellethToken,0,_projectTokenName,0,'',true);

        // MiniMeToken _projectToken = //0x0;
        // new MiniMeToken(
        //     tokenFactory,
        //     0,
        //     0,
        //     _projectTokenName,
        //     0,
        //     '',
        //     true
        //     );

         // ProjectTokenController tk = new ProjectTokenController();
         // _projectToken.changeController(tk);

        return IMiniMeToken(0x0);
        //return 0;
  }
       
}