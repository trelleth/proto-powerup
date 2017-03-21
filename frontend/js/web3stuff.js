// Trelleth blockchainz stuff

var contractAbi = [{"constant":false,"inputs":[{"name":"_trelloCardId","type":"string"},{"name":"_matchAmount","type":"uint256"}],"name":"trellethIt","outputs":[{"name":"","type":"address"}],"payable":false,"type":"function"}];
var contractAddress = "0x73caed002843d980889538bf1a5dd22a4ed5e633";

var web3 = new Web3(new Web3.providers.HttpProvider("https://metamask.io"));
console.log('web3? ', web3.isConnected());
//;
var myContract = web3.eth.contract(contractAbi)
var myContractinstance = myContract.at(contractAddress);

myContractinstance.trellethIt.sendTransaction("trellocardjeId", 10, function(err, res){
  console.log(err, res);
});

// myContractinstance.trellethIt.sendTransaction(contractAddress, 10000000000000000, "trllocardid", 10, function(err, res){
//   console.log(err, res);
// });
var myPort=chrome.extension.connect('nkbihfbeogaeaoehlefnkodbefgpgknn');

~/.config/google-chrome/Default/Extensions/nkbihfbeogaeaoehlefnkodbefgpgknn/3.4.0_0
