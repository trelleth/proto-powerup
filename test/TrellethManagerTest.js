var MiniMeTokenFactory = artifacts.require("./MiniMeToken.sol");
var MiniMeToken = artifacts.require("./MiniMeToken.sol");
//var TrellethTokenController = artifacts.require("./MiniMeToken.sol");
var TrellethManager = artifacts.require("./TrellethManager.sol");
//var TrellethFactory = artifacts.require("./TrellethFactory.sol");
var CardTokenController = artifacts.require("./CardTokenController.sol");
var CardTokenControllerFactory = artifacts.require("./CardTokenController.sol");
var ProjectTokenController = artifacts.require("./ProjectTokenController.sol");
var ProjectTokenControllerFactory = artifacts.require("./ProjectTokenController.sol");

contract('TrellethTokenController', function(accounts) {

  var deposit_address = accounts[1];

  var miniMeTokenFactory;
  var projectTokenControllerFactory;
  var cardTokenControllerFactory;

  var TrellethManagerInstance;
  var projectToken;
  var projectTokenController;
  var cardToken;
  var cardTokenController;


  var self = this;

  describe('Deploy Factories', function() {

    it("should deploy MiniMeTokenFactory contract", function(done) {
      MiniMeTokenFactory.new({
        gas: 4700000
      }).then(function(_instance) {
        assert.ok(_instance.address);
        miniMeTokenFactory = _instance;
        console.log('MiniMeTokenFactory created at address', _instance.address);
        self.web3.eth.getTransactionReceipt(_instance.transactionHash, function(err, receipt) {
          console.log('gas used =', receipt.gasUsed);
          done();
        });
        //done();
      });
    });

    it("should deploy ProjectTokenControllerFactory contract", function(done) {
      ProjectTokenControllerFactory.new(miniMeTokenFactory.address, {
        gas: 4700000
      }).then(function(_instance) {
        assert.ok(_instance.address);
        projectTokenControllerFactory = _instance;
        console.log('ProjectTokenControllerFactory created at address', _instance.address);
        self.web3.eth.getTransactionReceipt(_instance.transactionHash, function(err, receipt) {
          console.log('gas used =', receipt.gasUsed);
          done();
        });
        //done();
      });
    });

    it("should deploy CardTokenControllerFactory contract", function(done) {
      CardTokenControllerFactory.new(miniMeTokenFactory.address, {
        gas: 4700000
      }).then(function(_instance) {
        assert.ok(_instance.address);
        cardTokenControllerFactory = _instance;
        console.log('CardTokenControllerFactory created at address', _instance.address);
        self.web3.eth.getTransactionReceipt(_instance.transactionHash, function(err, receipt) {
          console.log('gas used =', receipt.gasUsed);
          done();
        });
        //done();
      });
    });

  });

  describe('Deploy TrellethManager', function() {
    it("should deploy TrellethManager", function(done) {

      TrellethManager.new({
        gas: 4700000
      }).then(function(_TrellethManagerInstance) {
        assert.ok(_TrellethManagerInstance.address);
        TrellethManagerInstance = _TrellethManagerInstance;
        console.log('TrellethManagerInstance created at address', _TrellethManagerInstance.address);
        self.web3.eth.getTransactionReceipt(_TrellethManagerInstance.transactionHash, function(err, receipt) {
          console.log('gas used =', receipt.gasUsed);
          done();
        });
      });

    });

    it("should call setFactories on TrellethManager", function(done) {

      TrellethManagerInstance.setFactories(projectTokenControllerFactory.address, cardTokenControllerFactory.address, {
        gas: 4700000
      }).then(function(_res) {
        //console.log(_res,a);
        //assert.ok(_TrellethManagerInstance.address);
        //TrellethManagerInstance = _TrellethManagerInstance;
        //console.log('TrellethManagerInstance created at address', _TrellethManagerInstance.address);
        self.web3.eth.getTransactionReceipt(_res.receipt.transactionHash, function(err, receipt) {
          console.log('gas used =', receipt.gasUsed);
          done();
        });
//        done();
      });

    });



    // it("should deploy projectToken contract", function(done) {
    //   MiniMeToken.new(
    //         miniMeTokenFactory.address,
    //         0,
    //         0,
    //         "My project Token",
    //         0,
    //         "MYPTOK",
    //         true
    //     ).then(function(_miniMeToken) {
    //     assert.ok(_miniMeToken.address);
    //     projectToken = _miniMeToken;
    //     console.log('projectToken created at address', _miniMeToken.address);
    //     done();
    //   });
    // });

    // it("should deploy projectTokenController contract", function(done) {
    //    ProjectTokenController.new("My Project Token"
    //          //projectToken.address
    //      ).then(function(_projectTokenController) {
    //      assert.ok(_projectTokenController.address);
    //      projectTokenController = _projectTokenController;
    //      console.log('projectTokenController created at address', _projectTokenController.address);
    //      done();
    //    });
    //  });

    it("account[0] should have no project token", function(done) {
      TrellethManagerInstance.myProjectsCounts(accounts[0]).then(function(_res) {
        assert.equal(_res.valueOf(), 0);
        done();
      });
    });

    it("account[0] should create a new project", function(done) {

      var events = TrellethManagerInstance.NewProject({
        fromBlock: "latest"
      });
      var listener = events.watch(function(error, result) {
        // This will catch all events, regardless of how they originated.
        if (error == null && result.args && result.args.projectToken) {
          projectToken = result.args.projectToken;
          projectTokenController = result.args.projectTokenController;
          console.log('new project token deployed at', projectToken);
          //console.log('new project token controller at', projectTokenController);
          listener.stopWatching();
          done();
        }
      });

      // var g = TrellethManagerInstance.makeProject.estimateGas("board1token", "b1t",projectTokenController.address).then(function(r){
      //   console.log('Estimated GAS=',r);
      // });

      TrellethManagerInstance.makeProject(0, {
        gas: 4700000
      }).then(function(_res) {
        self.web3.eth.getTransactionReceipt(_res.receipt.transactionHash, function(err, receipt) {
          console.log('gas used =', receipt.gasUsed);
          done();
        });        
      }).catch(function(e) {
        console.log(e);
        assert.fail(null, null, 'this function should not throw', e);
        done();
      }).catch(function(e) {
        done();
      });

    });

    // it("account[0] should have a new project / token", function(done) {
    //   TrellethManagerInstance.myProjectsCounts(accounts[0]).then(function(_res) {
    //     assert.equal(_res.valueOf(), 1);
    //     done();
    //   });
    // });

    // it("account[0] should own the project token", function(done) {
    //   assert.ok(projectToken);
    //   TrellethManagerInstance.projectOwner(self.web3.toHex(projectToken)).then(function(_res) {
    //     assert.equal(_res.valueOf(), self.web3.toHex(accounts[0]));
    //     done();
    //   });
    // });

    // it("account[1] should not own the project token", function(done) {
    //   assert.ok(projectToken);
    //   TrellethManagerInstance.projectOwner(self.web3.toHex(projectToken)).then(function(_res) {
    //     assert.notEqual(_res.valueOf(), self.web3.toHex(accounts[1]));
    //     done();
    //   });
    // });

    // it("account[0] should be able to attach a board to his project token", function(done) {
    //   assert.ok(projectToken);
    //   TrellethManagerInstance.attachBoard(self.web3.toHex(projectToken), "board1").then(function(_res) {
    //     done();
    //   }).catch(function(e) {
    //     assert.fail(null, null, 'this function should not throw', e);
    //     done();
    //   });;
    // });

    // it("account[1] should not be able to attach a board to account[0]'s project token", function(done) {
    //   assert.ok(projectToken);
    //   TrellethManagerInstance.attachBoard(self.web3.toHex(projectToken), "board2", {
    //     from: accounts[1]
    //   }).then(function(_res) {
    //     assert.fail(null, null, 'this function should throw', e);
    //     done();
    //   }).catch(function(e) {
    //     done();
    //   });;
    // });

    // it("board should point to my project token", function(done) {
    //   TrellethManagerInstance.getBoardAddress.call("board1").then(function(_res) {
    //     assert.equal(_res.valueOf(), self.web3.toHex(projectToken));
    //     done();
    //   });
    // });

  });

  // describe('Trelleth cards', function() {

  //   // it("should deploy projectTokenController contract", function(done) {
  //   //      CardTokenController.new("My Project Token"
  //   //            //projectToken.address
  //   //        ).then(function(_projectTokenController) {
  //   //        assert.ok(_projectTokenController.address);
  //   //        projectTokenController = _projectTokenController;
  //   //        console.log('projectTokenController created at address', _projectTokenController.address);
  //   //        done();
  //   //      });
  //   //    });

  //   it("board should TrellETH a Card", function(done) {

  //     TrellethManagerInstance.trellethIt.estimateGas("mycard1", "board1").then(function(_res) {
  //       console.log('estimated gas for trellethIt=', _res);
  //     });

  //     var events = TrellethManagerInstance.TrellEthed({
  //       fromBlock: "latest"
  //     });
  //     var listener = events.watch(function(error, result) {
  //       // This will catch all events, regardless of how they originated.
  //       if (error == null && result.args) {
  //         console.log(result.args);
  //         //cardToken = result.args.cardToken;
  //         //cardTokenController = CardTokenController.at(result.args.cardTokenController);
  //         listener.stopWatching();
  //         done();
  //       }
  //     });

  //     TrellethManagerInstance.trellethIt("mycard1", "board1").then(function(_res) {});
  //   });
  // });

  // describe('Happy Flow', function() {

  //   it("accounts[0] should appoint accounts[1] as supplier to the Card", function(done) {
  //     //var tc = CardTokenController.at(cardTokenController);
  //     cardTokenController.assignSupplier(accounts[1]).then(function(_res) {
  //       done();
  //     });
  //   });

  //   it("accounts[1] should claim the Card", function(done) {

  //     var events = cardTokenController.CardClaimed({
  //       fromBlock: "latest"
  //     });
  //     var listener = events.watch(function(error, result) {
  //       // This will catch all events, regardless of how they originated.
  //       if (error == null && result.args) {
  //         console.log(result.args);
  //         listener.stopWatching();
  //         done();
  //       }
  //     });

  //     cardTokenController.claim({
  //       from: accounts[1]
  //     }).then(function(_res) {});
  //   });

  //  it("accounts[0] should approve the work", function(done) {
  //     //var tc = CardTokenController.at(cardTokenController);
  //     cardTokenController.approve().then(function(_res) {
  //       done();
  //     });
  //   });


  //  });


  // describe('Deploy MiniMeToken Token & TrellethTokenController', function() {

  //   var hashtagToken;

  //   it("should deploy MiniMeToken contract", function(done) {
  //     MiniMeToken.new(
  //       miniMeTokenFactory.address,
  //       0,
  //       0,
  //       "Card1Token",
  //       18,
  //       "TT",
  //       true
  //     ).then(function(_miniMeToken) {
  //       assert.ok(_miniMeToken.address);
  //       console.log('Hashtag token created at address', _miniMeToken.address);
  //       hashtagToken = _miniMeToken;
  //       done();
  //     });
  //   });

  //   it("should deploy Controller", function(done) {
  //     TrellethTokenController.new(deposit_address, hashtagToken.address, arcToken.address).then(function(instance) {
  //       swtConverter = instance;
  //       assert.isNotNull(swtConverter);
  //       done();
  //     });
  //   });

  //   it("should set token's controller to TrellethTokenController", function(done) {
  //     hashtagToken.changeController(swtConverter.address).then(function() {
  //       done();
  //     }).catch(function(e) {
  //       assert.fail(null, null, 'this function should not throw', e);
  //       done();
  //     });
  //   });
  // });

  // describe('Convert ARC to SWT fails without having an allowance', function() {

  //   it("should not be able to convert without allowance", function(done) {
  //     swtConverter.convert(1).then(function() {
  //       assert.fail(null, null, 'This function should throw');
  //       done();
  //     }).catch(function() {
  //       done();
  //     });
  //   });
  // });

  // describe('Convert ARC to SWT with allowance', function() {

  //   it("should have correct balance on random token contract", function(done) {
  //     var balance = arcToken.balanceOf.call(accounts[0]).then(function(balance) {
  //       assert.equal(balance.valueOf(), 1000 * 1e18, "account not correct amount");
  //       done();
  //     });
  //   });

  //   it("should have zero balance on SWT token contract", function(done) {
  //     var balance = hashtagToken.balanceOf.call(accounts[0]).then(function(balance) {
  //       assert.equal(balance.valueOf(), 0, "account not correct amount");
  //       done();
  //     });
  //   });

  //   it("should give allowance to convert", function(done) {
  //     var balance = arcToken.balanceOf.call(accounts[0]).then(function(balance) {
  //       assert.equal(balance.valueOf(), 1000 * 1e18, "account not correct amount");
  //       arcToken.approve(swtConverter.address, balance).then(function() {
  //         done();
  //       });
  //     });
  //   });

  //   it("allowance should be visible in ARC token contract", function(done) {
  //     var balance = arcToken.allowance.call(accounts[0], swtConverter.address).then(function(allowanceamount) {
  //       assert.equal(allowanceamount.valueOf(), 1000 * 1e18, "allowanceamount not correct");
  //       done();
  //     });
  //   });

  //   it("should convert half of the ARC of this owner", function(done) {
  //     var balance = arcToken.balanceOf.call(accounts[0]).then(function(balance) {
  //       swtConverter.convert(balance.valueOf() / 2, {
  //         gas: 400000
  //       }).then(function() {
  //         done();
  //       }).catch(function(e) {
  //         assert.fail(null, null, 'This function should not throw', e);
  //         done();
  //       });
  //     });
  //   });

  //   it("should have the correct balance on SWT token contract", function(done) {
  //     var balance = hashtagToken.balanceOf.call(accounts[0]).then(function(balance) {
  //       assert.equal(balance.valueOf(), 1000 / 2 * 1e18, "account not correct amount");
  //       done();
  //     });
  //   });

  //   it("there should be an ARC balance on the deposit wallet", function(done) {
  //     var balance = arcToken.balanceOf.call(deposit_address).then(function(balance) {
  //       assert.equal(balance.valueOf(), 1000 / 2 * 1e18, "account not correct amount");
  //       done();
  //     });
  //   });

  //   it("should convert remaining balance of this owner", function(done) {
  //     var balance = arcToken.balanceOf.call(accounts[0]).then(function(balance) {
  //       swtConverter.convert(balance.valueOf(), {
  //         gas: 400000
  //       }).then(function() {
  //         done();
  //       }).catch(function(e) {
  //         assert.fail(null, null, 'This function should not throw', e);
  //         done();
  //       });
  //     });
  //   });

  //   it("should not be able to convert more tokens", function(done) {
  //     swtConverter.convert(1, {
  //       gas: 400000
  //     }).then(function() {
  //       assert.fail(null, null, 'This function should throw', e);
  //       done();
  //     }).catch(function(e) {
  //       done();
  //     });
  //   });

  //   it("should have new balance on SWT token contract", function(done) {
  //     var balance = hashtagToken.balanceOf.call(accounts[0]).then(function(balance) {
  //       assert.equal(balance.valueOf(), 1000 * 1e18, "account not correct amount");
  //       done();
  //     });
  //   });

  //   it("should have zero balance on ARC token contract", function(done) {
  //     var balance = arcToken.balanceOf.call(accounts[0]).then(function(balance) {
  //       assert.equal(balance.valueOf(), 0, "account not correct amount");
  //       done();
  //     });
  //   });

  //   it("there should be an ARC balance on the deposit wallet", function(done) {
  //     var balance = arcToken.balanceOf.call(deposit_address).then(function(balance) {
  //       assert.equal(balance.valueOf(), 1000 * 1e18, "account not correct amount");
  //       done();
  //     });
  //   });
  // });

  // describe('Cloning of contract at current block', function() {

  //   it("should be able to clone this contract at block " + self.web3.eth.blockNumber, function(done) {

  //     var watcher = hashtagToken.NewCloneToken();
  //     watcher.watch(function(error, result) {
  //       console.log('new clone contract at ', result.args._cloneToken);
  //       clone0 = MiniMeToken.at(self.web3.toHex(result.args._cloneToken));
  //       watcher.stopWatching();
  //       done();
  //     });

  //     hashtagToken.createCloneToken(
  //       "Swarm Voting Token",
  //       18,
  //       "SVT",
  //       Number.MAX_SAFE_INTEGER, // if the blocknumber > current block, minime defaults to the current block.
  //       true, {
  //         gas: 2000000
  //       }).then(function(txhash) {
  //       // the event watcher will call done()
  //     }).catch(function(e) {
  //       console.log('Error', e);
  //       assert.fail(null, null, 'This function should not throw', e);
  //       done();
  //     });
  //   });

  //   it("should be have the same balance as the original ", function(done) {
  //     var balance = clone0.balanceOf.call(accounts[0]).then(function(balance) {
  //       assert.equal(balance.valueOf(), 1000 * 1e18, "account not correct amount");
  //       done();
  //     });
  //   });
  // });


  // describe('Cloning of contract at block 0', function() {

  //   it("should be able to clone this contract at block 0", function(done) {
  //     var watcher = hashtagToken.NewCloneToken();
  //     watcher.watch(function(error, result) {
  //       console.log('new clone contract at ', result.args._cloneToken);
  //       clone1 = MiniMeToken.at(self.web3.toHex(result.args._cloneToken));
  //       watcher.stopWatching();
  //       done();
  //     });

  //     hashtagToken.createCloneToken(
  //       "Swarm Voting Token",
  //       18,
  //       "SVT",
  //       0,
  //       true, {
  //         gas: 2000000
  //       }).then(function(txhash) {
  //       // the event watcher will call done()
  //     }).catch(function(e) {
  //       console.log('Error', e);
  //       assert.fail(null, null, 'This function should not throw', e);
  //       done();
  //     });
  //   });

  //   it("should be have a zero SWT balance ", function(done) {
  //     var balance = clone1.balanceOf.call(accounts[0]).then(function(balance) {
  //       assert.equal(balance.valueOf(), 0, "account not correct amount");
  //       done();
  //     });
  //   });
  // });


});