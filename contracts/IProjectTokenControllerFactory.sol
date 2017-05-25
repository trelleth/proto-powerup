pragma solidity ^0.4.8;
import "./IMiniMeToken.sol";
contract IProjectTokenControllerFactory {
  function test();
  function makeProjectToken(string _projectTokenName) returns(IMiniMeToken);
}
