/* global TrelloPowerUp */

var t = TrelloPowerUp.iframe();

// you can access arguments passed to your iframe like so
var num = t.arg('rand');

t.render(function(){
  //debugger;
  //console.log('web3', window.web3.isConnected());
  // this function we be called once on initial load
  // and then called each time something changes that
  // you might want to react to, such as new data being
  // stored with t.set()

  t.board('id', 'name', 'url', 'shortLink', 'members').then(function(promiseResult){
    console.log(promiseResult);
    var boardidplace = document.getElementById('getboard');
    boardidplace.boardid = promiseResult.id;
  });


});

// document.getElementById('icobtn').addEventListener('click', function(){
//   //console.log('icobtn clickced', t.iframe.web3.currentProvider());
//
//
// var contractAbi = [{"constant":false,"inputs":[{"name":"_trelloCardId","type":"string"},{"name":"_matchAmount","type":"uint256"}],"name":"trellethIt","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"}];
// var contractAddress = "0x73caed002843d980889538bf1a5dd22a4ed5e633";
//
// debugger;
// //var web3 = window.parent.web3;
// //var web3 = new Web3(new Web3.providers.HttpProvider("https://metamask.io"));
// console.log('web3? ', web3.isConnected());
// //;
//  var myContract = web3.eth.contract(contractAbi)
//  var myContractinstance = myContract.at(contractAddress);
//
// // myContractinstance.trellethIt.sendTransaction("trellocardjeId", 10, function(err, res){
// //   console.log(err, res);
// // });
//
// myContractinstance.trellethIt.sendTransaction(contractAddress, 10000000000000000, "trllocardid", 10, function(err, res){
//   console.log(err, res);
// });
//
//
//
// });

// close overlay if user clicks outside our content
document.addEventListener('click', function(e) {
  if(e.target.tagName == 'BODY') {
    t.closeOverlay().done();
  }
});

// close overlay if user presses escape key
document.addEventListener('keyup', function(e) {
  if(e.keyCode == 27) {
    t.closeOverlay().done();
  }
});
