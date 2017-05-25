pragma solidity ^0.4.8;

contract ICardTokenControllerFactory {
  function makeCardToken(string _cardTokenName,address _projectToken) returns(address);
}
