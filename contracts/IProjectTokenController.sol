pragma solidity ^0.4.8;

contract IProjectTokenController {
  function proxyPayment(address _owner) payable returns(bool);
  function onTransfer(address _from, address _to, uint _amount) returns(bool);
  function onApprove(address _owner, address _spender, uint _amount) returns(bool);
}
