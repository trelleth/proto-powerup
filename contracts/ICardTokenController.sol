pragma solidity ^0.4.8;

contract ICardTokenController {
  enum CardStatuses {
        Open,
        Claimed,
        Approved,
        Rejected
  }	
  function allowedSupplier() public constant returns(address);
  function cardstatus() public constant returns(CardStatuses);
  function proxyPayment(address _owner) payable returns(bool);
  function onTransfer(address _from, address _to, uint _amount) returns(bool);
  function onApprove(address _owner, address _spender, uint _amount) returns(bool);
  function assignSupplier(address _supplier);
  function claim();
  function approve();
  function fuckYou();
}
