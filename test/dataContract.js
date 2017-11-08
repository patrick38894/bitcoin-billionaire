var DataContract = artifacts.require("./DataContract.sol");

contract('DataContract', function(accounts) {

  var coinId;

  //before(function() {
  //  return DataContract.deployed().then(function(instance) {
  //    instance.addCoin.call("Bitcoin","The original cryptocurrency","BTC").then( function(value) {
  //      coinId = value;
  //    });
  //  });
  //});
  //
  
  //todo: this hangs presumably because there is no done() call

  it("should check the new coin id", function(accounts) {
    return DataContract.deployed().then(function(instance) {
      return instance.addCoin("Bitcoin","The original cryptocurrency","BTC")
      .then(function(value) {
        return instance.coinNextId.call();
      }).then(function(value) {
        assert.equal(value.valueOf(), 2, "there should be 1 coin");
      });
      // todo still hangs because of done() thing;
      //
    //  return instance.coinTable(1);
    //}).then(function(value) {
    //    assert.equal(value[0].valueOf(), 1, "the id of the first coin should be 1");
    //    assert.equal(value[1].valueOf(), "Bitcoin", "the name of the coin should be 'Bitcoin'");
    //    assert.equal(value[2].valueOf(), "BTC", "the abbreviation of the coin should be 'BTC'");
    //    assert.equal(value[3].valueOf(), "The original cryptocurrency" ,"coin description does not match");
    //  });
    });
  });


  // it("should get the coin name"
  // it("should get the coin description"
  // it("should get the coin short name"

  // it("should add a new item"
  // it("should get the item name"
  // it("should get the item description"
  // it("should get the item coin id"
  // it("should get the item base price"
  // it("should get the item base income"
});
